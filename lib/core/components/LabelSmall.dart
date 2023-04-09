import 'package:flutter/cupertino.dart';

class LabelSmall extends StatelessWidget{
  final String text;

  const LabelSmall({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1.45,
      ),
    );
  }

}