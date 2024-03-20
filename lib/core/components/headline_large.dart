import 'package:flutter/cupertino.dart';

class HeadlineLarge extends StatelessWidget{
  final String text;
  final Color? color;

  const HeadlineLarge({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          height: 1.25,
        color: color
      ),
    );
  }

}