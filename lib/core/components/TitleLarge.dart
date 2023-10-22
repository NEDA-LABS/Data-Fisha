import 'package:flutter/cupertino.dart';

class TitleLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const TitleLarge({Key? key, required this.text, this.overflow, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 22,
          height: 1.27,
          overflow: overflow,
          color: color),
    );
  }
}
