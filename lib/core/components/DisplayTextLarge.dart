import 'package:flutter/cupertino.dart';

class DisplayTextLarge extends StatelessWidget {
  final String text;

  const DisplayTextLarge({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 57,
        height: 1.12
      ),
    );
  }
}
