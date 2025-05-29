import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/common/user/user_manager.dart';
import 'package:tudo/common/widget/base_widget.dart';
import 'package:tudo/pages/root/root_page_controller.dart';
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
        Btn(
          "手机号登录",
          onPressed: () {
            if (Get.isRegistered<RootPageController>()) {
              Get.find<RootPageController>().initAfterAgree();
            }
            UserManager.instance.toLoginStep();
          },
        ),
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
                text: "已阅读并同意",
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: "隐私政策",
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
              TextSpan(text: "和"),
              TextSpan(
                text: "服务条款",
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
