import 'package:flutter/cupertino.dart';

class TitleSmall extends StatelessWidget{
  final String text;

  const TitleSmall({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.43,
      ),
    );
  }

}