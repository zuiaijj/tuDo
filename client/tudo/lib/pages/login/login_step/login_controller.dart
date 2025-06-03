import 'package:tudo/common/const/root_const.dart';
import 'package:tudo/common/net/http/model/base_net_model.dart';
import 'package:tudo/common/user/user_manager.dart';
import 'package:tudo/common/user/user_model.dart';
import 'package:tudo/pages/login/login_step/country_code/country_code_model.dart';
import 'package:tudo/pages/login/login_step/login_helper.dart';
import 'package:tudo/pages/login/net/login_net.dart';
import 'package:tudo/pages/root/root_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo/tool/intl_tool.dart';

enum LoginStep {
  phone,
  verifyCode,
  name,
}

class LoginStepConfig {
  final String title;
  final LoginStep step;
  final String dec;
  final String stepTitle;
  final bool canSkip;
  final bool centerBtn; // 是否居中按钮,否则的话，展示在底部

  LoginStepConfig({
    required this.title,
    required this.step,
    required this.dec,
    required this.stepTitle,
    required this.canSkip,
    this.centerBtn = true,
  });
}

class LoginController extends GetxController {
  final LoginStep? startStep;
  String? _sendCodeRequestId;

  final RxString phone = ''.obs;
  final RxString code = ''.obs;
  final Rx<UserModel> editUser = UserModel.empty().obs;

  final Rx<CountryCodeModel> countryCode =
      CountryCodeModel(name: 'China', code: 'CN', dialCode: '+86').obs;
  final Rx<LoginStep> currentStep = LoginStep.phone.obs;

  final RxBool isContinueEnable = false.obs;
  final RxBool isRequesting = false.obs;

  final RxList<LoginStepConfig> steps = [
    LoginStepConfig(
      title: intlS.login_welcome,
      step: LoginStep.phone,
      dec: intlS.will_send_auth,
      stepTitle: intlS.send_auth_code,
      canSkip: false,
      centerBtn: false,
    ),
    LoginStepConfig(
      title: intlS.v_code_login,
      step: LoginStep.verifyCode,
      dec: intlS.enter_v_code_tip,
      stepTitle: intlS.login_continue,
      canSkip: false,
      centerBtn: false,
    ),
    LoginStepConfig(
      title: intlS.create_nick_title,
      step: LoginStep.name,
      dec: intlS.create_nick_tip,
      stepTitle: intlS.login_continue,
      canSkip: false,
      centerBtn: false,
    ),
  ].obs;

  LoginController(this.startStep) {
    currentStep.value = startStep ?? LoginStep.phone;
    editUser.value = UserManager.instance.user ?? UserModel.empty();
  }

  ///  ----------- on Step action ------------
  /// 点击继续
  onStepContinue() async {
    if (isRequesting.value) {
      return;
    }
    bool isSuccess = false;
    switch (currentStep.value) {
      case LoginStep.phone:
        isSuccess = await _sendCode();
        break;
      case LoginStep.verifyCode:
        isSuccess = await _checkVerifyCode();
        break;
      case LoginStep.name:
        isSuccess = await _setName();
        break;
    }
    if (isSuccess) {
      _onChangeStepForward();
    }
  }

  /// 点击跳过
  onStepSkip() {
    _onChangeStepForward();
  }

  /// 点击返回
  onStepBack() {
    switch (currentStep.value) {
      case LoginStep.phone:
        phone.value = '';
        break;
      case LoginStep.verifyCode:
        code.value = '';
        break;
      case LoginStep.name:
        editUser.value.name = '';
        break;
    }
    _onChangeStepBackward();
  }

  _onChangeStepBackward() {
    if (currentStep.value == startStep && startStep != null) {
      UserManager.instance.logout();
      return;
    }
    if (!steps.any((element) => element.step == currentStep.value)) {
      Get.back();
      return;
    }
    int index =
        steps.indexWhere((element) => element.step == currentStep.value);
    if (index == -1 || index == 0) {
      Get.back();
      return;
    }
    _updateCurrentStep(steps[index - 1].step);
  }

  _onChangeStepForward() {
    if (!steps.any((element) => element.step == currentStep.value)) {
      return;
    }
    int index =
        steps.indexWhere((element) => element.step == currentStep.value);
    if (index == -1) {
      _updateCurrentStep(steps[0].step);
      return;
    }
    // 如果是最后一个步骤，则登录成功
    if (index == steps.length - 1) {
      loginSuccess();
      return;
    }
    // 如果是验证码步骤，验证成功
    if (currentStep.value.index == LoginStep.verifyCode.index) {
      bool hasName = UserManager.instance.user?.name.isNotEmpty ?? false;
      if (!hasName) {
        _updateCurrentStep(LoginStep.name);
        return;
      }
      loginSuccess();
      return;
    }
    _updateCurrentStep(steps[index + 1].step,
        oldIndex: index, newIndex: index + 1);
  }

  _updateCurrentStep(LoginStep step, {int? oldIndex, int? newIndex}) {
    if (oldIndex != null &&
        newIndex != null &&
        steps[oldIndex].centerBtn != steps[newIndex].centerBtn &&
        steps[oldIndex].centerBtn) {
      FocusScope.of(Get.context!).unfocus();
    }
    if (currentStep.value == step) {
      return;
    }
    currentStep.value = step;
    _updateContinueEnable();
    update();
  }

  _updateContinueEnable() {
    switch (currentStep.value) {
      case LoginStep.phone:
        isContinueEnable.value = isValidPhoneNumber(phone.value,
            areaCode: countryCode.value.dialCode);
        break;
      case LoginStep.verifyCode:
        isContinueEnable.value = code.value.length >= 4;
        break;
      case LoginStep.name:
        isContinueEnable.value = editUser.value.name.trim().isNotEmpty;
        break;
    }
    update();
  }

  ///  ----------- on Step action ------------

  ///  ----------- input check ------------
  onPhoneChange(CountryCodeModel model, String phone) {
    countryCode.value = model;
    this.phone.value = phone;
    _updateContinueEnable();
  }

  onVerifyCodeChange(String code) {
    this.code.value = code;
    _updateContinueEnable();
  }

  onNameChange(String name) {
    editUser.value.name = name;
    _updateContinueEnable();
  }

  resendCode() async {
    _sendCodeRequestId = null;
    await _sendCode();
  }

  ///  ----------- input check ------------

  ///  ----------- on server action ------------
  Future<bool> _sendCode() async {
    isRequesting.value = true;
    BaseNetRes? res = await LoginNet.sendCode(
        phone.value, countryCode.value.dialCode?.substring(1) ?? "");
    isRequesting.value = false;
    if (res == null) {
      return false;
    }
    _sendCodeRequestId = res.data['code_req'];
    return true;
  }

  Future<bool> _checkVerifyCode() async {
    // isRequesting.value = true;
    // UserModel? user = await LoginNet.loginVerifyCode(
    //     phone.value,
    //     code.value,
    //     countryCode.value.dialCode?.substring(1) ?? "",
    //     _sendCodeRequestId ?? "",
    //     countryCode.value.code ?? "");
    // isRequesting.value = false;
    // if (user == null) {
    //   return false;
    // }
    // UserManager.instance.user = user;
    // editUser.value = user;
    return true;
  }

  Future<bool> _setName() async {
    // isRequesting.value = true;
    // bool isSuccess = await _updateUserProfile({
    //   "name": editUser.value.name,
    // });
    // isRequesting.value = false;
    // return isSuccess;
    return true;
  }

  Future<bool> _updateUserProfile(Map<String, dynamic> params) async {
    bool isSuccess = await LoginNet.setProfile(params);
    if (isSuccess) {
      UserManager.instance.updateSingaleInfo(infoMap: params);
    }
    return isSuccess;
  }

  ///  ----------- on server action ------------

  loginSuccess() async {
    if (Get.isRegistered<RootPageController>()) {
      RootPageController rootPageController = Get.find<RootPageController>();
      await rootPageController.initAfterLogin();
    }
    Get.until((route) => route.settings.name == RouteConst.root);
  }
}
