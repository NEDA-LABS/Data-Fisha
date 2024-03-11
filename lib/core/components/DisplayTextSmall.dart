import 'package:flutter/cupertino.dart';

class DisplayTextSmall extends StatelessWidget {
  final String text;

  const DisplayTextSmall({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 36,
        height: 1.22
      ),
    );
  }
}
