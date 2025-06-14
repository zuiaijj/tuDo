import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/intl_tool.dart';

class NameStep extends StatefulWidget {
  const NameStep({super.key, required this.onNameChange, required this.name});
  final Function(String) onNameChange;
  final String name;

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _nameController.text = widget.name;
    _listenNameChange();
    super.initState();
  }

  _listenNameChange() {
    _nameController.addListener(_onNameChange);
  }

  _onNameChange() {
    widget.onNameChange(_nameController.text);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChange);
    _nameController.dispose();
    _focusNode.dispose();
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
          _buildNameInput(),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        controller: _nameController,
        keyboardAppearance: colorScheme.brightness,
        autofocus: true,
        textCapitalization: TextCapitalization.words, // 首字母大写
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
        maxLength: 15,
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
}
