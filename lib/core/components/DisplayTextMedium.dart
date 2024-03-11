import 'package:flutter/cupertino.dart';

class DisplayTextMedium extends StatelessWidget {
  final Color? color;
  final String text;

  const DisplayTextMedium({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 45,
        height: 1.16,
        color: color
      ),
    );
  }
}
