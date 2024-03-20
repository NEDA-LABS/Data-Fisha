import 'package:flutter/cupertino.dart';

class HeadlineMedium extends StatelessWidget {
  final String text;
  final Color? color;

  const HeadlineMedium({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          height: 1.29,
          color: color),
    );
  }
}
