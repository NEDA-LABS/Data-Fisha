import 'package:flutter/cupertino.dart';

class DisplayTextLarge extends StatelessWidget {
  final String text;

  const DisplayTextLarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 57,
        height: 1.12
      ),
    );
  }
}
