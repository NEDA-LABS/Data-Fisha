import 'package:flutter/cupertino.dart';

class TitleMedium extends StatelessWidget {
  final Color? color;
  final String text;

  const TitleMedium({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
        color: color
      ),
    );
  }
}
