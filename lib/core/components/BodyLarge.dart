import 'package:flutter/cupertino.dart';

class BodyLarge extends StatelessWidget{
  final String text;

  const BodyLarge({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
      ),
    );
  }

}