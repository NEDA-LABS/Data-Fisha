import 'package:flutter/cupertino.dart';

class BodyMedium extends StatelessWidget{
  final String text;

  const BodyMedium({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.43,
      ),
    );
  }

}