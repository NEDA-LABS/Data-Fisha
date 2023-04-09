import 'package:flutter/cupertino.dart';

class DisplayTextSmall extends StatelessWidget {
  final String text;

  const DisplayTextSmall({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 36,
        height: 1.22
      ),
    );
  }
}
