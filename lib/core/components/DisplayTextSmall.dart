import 'package:flutter/cupertino.dart';

class DisplayTextSmall extends StatelessWidget {
  final String text;
  final Color? color;

  const DisplayTextSmall({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 36,
        height: 1.22,
        color: color
      ),
    );
  }
}
