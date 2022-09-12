import 'package:flutter/material.dart';

outlineButton({Function? onPressed, required String title, Color? textColor}) => Container(
    height: 44,
    padding: const EdgeInsets.all(8),
    child: OutlinedButton(
        onPressed: onPressed as void Function()?,
        child: Text(title,
            style: TextStyle(fontWeight: FontWeight.w500, color: textColor))));
