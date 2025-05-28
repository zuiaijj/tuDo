import 'package:flutter/material.dart';
import 'package:tudo/tool/get_tool.dart';

Widget Btn(
  String text,
  VoidCallback onPressed,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: textTheme.titleSmall?.copyWith(color: colorScheme.onPrimary),
    ),
  );
}
