import 'package:flutter/cupertino.dart';

class HeadlineMedium extends StatelessWidget{
  final String text;

  const HeadlineMedium({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 28,
          height: 1.29
      ),
    );
  }

}