import 'package:flutter/cupertino.dart';

class HeadlineLarge extends StatelessWidget{
  final String text;

  const HeadlineLarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 32,
          height: 1.25
      ),
    );
  }

}