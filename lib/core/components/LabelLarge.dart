import 'package:flutter/cupertino.dart';

class LabelLarge extends StatelessWidget {
  final String text;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Color? color;

  const LabelLarge({super.key, required this.text, this.overflow, this.color, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.43,
          overflow: overflow,
          color: color),
    );
  }
}
