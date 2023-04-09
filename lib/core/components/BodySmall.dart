import 'package:flutter/material.dart';

class BodySmall extends StatelessWidget{
  final String text;

  const BodySmall({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          height: 1.33,
      ),
    );
  }

}