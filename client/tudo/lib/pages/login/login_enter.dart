import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tudo/common/widget/base_widget.dart';
import 'package:tudo/tool/intl_tool.dart';
import 'package:tudo/tool/get_tool.dart';

class LoginEnter extends StatelessWidget {
  const LoginEnter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          _maskBg(),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _buildLoginBtn(),
                    SizedBox(height: 50.h),
                    _buildPrivacyText(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _maskBg() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        width: screanWidth,
        child: Image.asset(
          isDarkMode
              ? 'assets/login/login_mask_black.png'
              : 'assets/login/login_mask_white.png',
          width: 58.w,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Btn(intlS.login_by_phone, () {}),
      ],
    );
  }

  Widget _buildPrivacyText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            children: [
              TextSpan(
                text: intlS.by_signing_up,
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: intlS.privacy_policy,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // UrlTool.launchURL(Get.context!, AppNetRes.privacy,
                    //     needMeta: false);
                  },
              ),
              TextSpan(text: intlS.and_no_trim),
              TextSpan(
                text: intlS.terms_service,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // UrlTool.launchURL(Get.context!, AppNetRes.service,
                    //     needMeta: false);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
