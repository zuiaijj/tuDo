import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/common/widget/base_widget.dart';
import 'package:tudo/pages/login/login_step/login_controller.dart';
import 'package:tudo/pages/login/login_step/step/name_step.dart';
import 'package:tudo/pages/login/login_step/step/phone_setp.dart';
import 'package:tudo/pages/login/login_step/step/verify_step.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/intl_tool.dart';

class LoginStepPage extends StatefulWidget {
  const LoginStepPage({super.key});

  @override
  State<LoginStepPage> createState() => _LoginStepPageState();
}

class _LoginStepPageState extends State<LoginStepPage> {
  LoginStep? _initStep;

  @override
  void initState() {
    super.initState();
    LoginStep? step = Get.arguments;
    if (step != null) {
      _initStep = step;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool result, t) {
        Get.find<LoginController>().onStepBack();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: GetBuilder<LoginController>(
          init: LoginController(_initStep),
          builder: (controller) {
            LoginStepConfig config = controller.steps.firstWhere(
                (element) => element.step == controller.currentStep.value);
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 返回按钮
                  Padding(
                    padding: EdgeInsets.only(left: 22.w, top: 12.h),
                    child: Row(
                      children: [
                        backBtn(controller.onStepBack),
                        const Spacer(),
                        if (config.canSkip)
                          TextButton(
                            onPressed: controller.onStepSkip,
                            child: Text(
                              intlS.common_skip,
                              style: textTheme.bodyLarge,
                            ),
                          ),
                        SizedBox(width: 20.w),
                      ],
                    ),
                  ),
                  SizedBox(height: 38.h),
                  // 标题和提示文本
                  _buildStepTitle(config),
                  SizedBox(height: (config.dec.isEmpty) ? 6.h : 32.h),
                  _stepContent(config, controller),
                  const Spacer(),
                  // Continue 按钮
                  _buildStepContinueButton(controller, config),
                  SizedBox(
                      height: config.centerBtn ? screanHeight.h * 0.3 : 16.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _stepContent(LoginStepConfig config, LoginController controller) {
    switch (config.step) {
      case LoginStep.phone:
        return PhoneStep(
            onChange: controller.onPhoneChange, phone: controller.phone.value);
      case LoginStep.verifyCode:
        return VerifyStep(
            onVerify: controller.onVerifyCodeChange,
            onResend: controller.resendCode,
            code: controller.code.value);
      case LoginStep.name:
        return NameStep(
            onNameChange: controller.onNameChange,
            name: controller.editUser.value.name);
    }
  }

  Widget _buildStepContinueButton(
      LoginController controller, LoginStepConfig config) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() {
        return Btn(
          config.stepTitle,
          onPressed: controller.isContinueEnable.value &&
                  !controller.isRequesting.value
              ? () => controller.onStepContinue()
              : () {},
          enabled: controller.isContinueEnable.value &&
              !controller.isRequesting.value,
          child: controller.isRequesting.value
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    color: colorScheme.onSurface,
                  ),
                )
              : null,
        );
      }),
    );
  }

  Widget _buildStepTitle(LoginStepConfig config) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config.title,
            style: textTheme.displaySmall,
          ),
          SizedBox(height: 12.h),
          Text(
            config.dec,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.primaryFixed,
            ),
          ),
        ],
      ),
    );
  }
}
