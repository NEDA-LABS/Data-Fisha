import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelMedium extends StatelessWidget {
  final String text;
  final TextOverflow? overflow;

  const LabelMedium({Key? key, required this.text, this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.33,
          overflow: overflow),
    );
  }
}
