import 'package:flutter/cupertino.dart';

class DisplayTextMedium extends StatelessWidget {
  final String text;

  const DisplayTextMedium({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 45,
        height: 1.16
      ),
    );
  }
}
