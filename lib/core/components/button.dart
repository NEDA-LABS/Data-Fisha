import 'package:flutter/material.dart';

outlineButton(
        {Function? onPressed,
        required String title,
        Color textColor = const Color(0xff061563)}) =>
    Container(
        height: 34,
        margin: const EdgeInsets.all(8),
        child: OutlinedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0x1a367ce5))),
            onPressed: onPressed as void Function()?,
            child: Text(title,
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 16))));
