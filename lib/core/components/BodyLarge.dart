import 'package:flutter/cupertino.dart';

class BodyLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final Color? color;

  const BodyLarge({
    Key? key,
    required this.text,
    this.textAlign,
    this.overflow, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
          color: color,
          overflow: overflow),
    );
  }
}
