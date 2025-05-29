import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/pages/login/login_step/country_code/country_code_model.dart';
import 'package:tudo/pages/login/login_step/country_code/country_code_picker.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/intl_tool.dart';

typedef PhoneStepChange = void Function(CountryCodeModel model, String phone);

class PhoneStep extends StatefulWidget {
  final String phone;
  const PhoneStep({super.key, required this.onChange, required this.phone});
  final PhoneStepChange onChange;

  @override
  State<PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<PhoneStep> {
  Rx<CountryCodeModel> countryCode = Rx<CountryCodeModel>(
      CountryCodeModel(name: 'Hongkong', code: 'HK', dialCode: '+852'));

  final FocusNode _focusNodePhone = FocusNode();
  final TextEditingController _phoneEditController = TextEditingController();

  @override
  void initState() {
    _phoneEditController.text = widget.phone;
    _listenPhoneChange();
    super.initState();
  }

  _listenPhoneChange() {
    _phoneEditController.addListener(_onChanged);
  }

  _onChanged() {
    widget.onChange(countryCode.value, _phoneEditController.text);
  }

  @override
  void dispose() {
    _phoneEditController.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16.w),
          _buildCountryCodePicker(),
          SizedBox(width: 6.w),
          _buildPhoneInput(),
        ],
      ),
    );
  }

  /// 输入手机号
  _buildPhoneInput() {
    return Expanded(
      child: TextField(
        focusNode: _focusNodePhone,
        controller: _phoneEditController,
        keyboardAppearance: Brightness.light,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.phone,
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        maxLength: 13,
        decoration: InputDecoration(
          counterText: '',
          isCollapsed: true,
          border: InputBorder.none,
          hintText: intlS.login_phone_hint,
          contentPadding: EdgeInsets.zero,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.outline,
          ),
          isDense: false,
        ),
      ),
    );
  }

  _buildCountryCodePicker() {
    return SizedBox(
      width: 80.w,
      child: Obx(() {
        return CountryCodePicker(
          initialSelection: countryCode.value.code,
          onInit: (value) {},
          onChanged: onCountryCodeChanged,
        );
      }),
    );
  }

  void onCountryCodeChanged(CountryCodeModel value) {
    countryCode.value = value;
    _phoneEditController.clear();
    _focusNodePhone.requestFocus();
    widget.onChange(value, _phoneEditController.text);
  }
}
