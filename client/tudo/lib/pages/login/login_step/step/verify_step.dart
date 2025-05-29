import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/intl_tool.dart';
import 'package:tudo/tool/timer_tool.dart';

class VerifyStep extends StatefulWidget {
  const VerifyStep(
      {super.key,
      required this.onVerify,
      required this.onResend,
      required this.code});
  final Function(String) onVerify;
  final Function onResend;
  final String code;

  @override
  State<VerifyStep> createState() => _VerifyStepState();
}

class _VerifyStepState extends State<VerifyStep> {
  final TextEditingController _codeEditController = TextEditingController();
  final FocusNode _focusNodeCode = FocusNode();

  TimerTool? _timer;
  final RxInt _countdownTime = 60.obs;

  bool get _isCountDown => _timer?.isActive() ?? false;

  @override
  void initState() {
    _codeEditController.text = widget.code;
    _listenCodeChange();
    _startCountDown();
    super.initState();
  }

  _listenCodeChange() {
    _codeEditController.addListener(_onCodeChange);
  }

  _onCodeChange() {
    widget.onVerify(_codeEditController.text);
  }

  @override
  void dispose() {
    _codeEditController.removeListener(_onCodeChange);
    _codeEditController.dispose();
    _focusNodeCode.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56.h,
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceDim,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCodeInput(),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _buildSendBtn(),
      ],
    );
  }

  /// 获取验证码
  _buildSendBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Obx(() {
        String countStr =
            intlS.login_verification_code_content(_countdownTime.value);
        String timeStr = _countdownTime.toString();
        String countStrP1 = "";
        String countStrP2 = "";
        String countStrP3 = "";
        if (_isCountDown) {
          List<String> counts = countStr.split(timeStr);
          countStrP1 = counts[0];
          countStrP2 = timeStr;
          if (counts.length > 1) {
            countStrP3 = counts[1];
          }
        }
        return InkWell(
          onTap: _clickResendBtn,
          child: _isCountDown
              ? Text.rich(
                  TextSpan(
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: countStrP1,
                      ),
                      TextSpan(
                          text: countStrP2,
                          style: TextStyle(color: colorScheme.secondary)),
                      TextSpan(
                        text: countStrP3,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                )
              : Text.rich(
                  TextSpan(
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: intlS.login_resend_code,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
        );
      }),
    );
  }

  _startCountDown() {
    _timer = TimerTool(mTotalSec: 60);
    _timer?.setOnTimerTickCallback((int time) {
      if (time == 0) {
        _countdownTime.value = 60;
      } else {
        _countdownTime.value = time;
      }
    });
    _timer?.startCountDown();
  }

  _clickResendBtn() {
    _startCountDown();
    widget.onResend();
  }

  _buildCodeInput() {
    return Expanded(
      child: TextField(
        focusNode: _focusNodeCode,
        controller: _codeEditController,
        keyboardAppearance: Brightness.light,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.phone,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF242427),
        ),
        textAlign: TextAlign.center,
        maxLength: 13,
        decoration: InputDecoration(
          counterText: '',
          isCollapsed: true,
          border: InputBorder.none,
          hintText: intlS.login_code_hint,
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(
            fontSize: 20.sp,
            height: 0.75,
            textBaseline: TextBaseline.alphabetic,
            fontWeight: FontWeight.w400,
            color: Color(0xFFA7A8AF),
          ),
          isDense: false,
        ),
      ),
    );
  }
}
