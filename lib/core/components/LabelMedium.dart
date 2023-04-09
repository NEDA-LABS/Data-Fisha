import 'package:flutter/cupertino.dart';

class LabelMedium extends StatelessWidget{
  final String text;

  const LabelMedium({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.33,
      ),
    );
  }

}