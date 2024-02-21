import 'package:flutter/cupertino.dart';

class BodyMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const BodyMedium({super.key, required this.text, this.color, this.textAlign, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.43,
        color: color,
        overflow: overflow
      ),
    );
  }
}
