import 'package:flutter/cupertino.dart';

class TitleLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const TitleLarge({super.key, required this.text, this.overflow, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          height: 1.27,
          overflow: overflow,
          color: color),
    );
  }
}
