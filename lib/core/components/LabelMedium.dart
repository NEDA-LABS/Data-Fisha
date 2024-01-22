import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelMedium extends StatelessWidget {
  final String text;
  final TextOverflow? overflow;
  final Color? color;

  const LabelMedium({super.key, required this.text, this.overflow, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.33,
          overflow: overflow),
    );
  }
}
