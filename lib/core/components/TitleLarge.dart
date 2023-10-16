import 'package:flutter/cupertino.dart';

class TitleLarge extends StatelessWidget{
  final String text;

  const TitleLarge({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 22,
          height: 1.27
      ),
    );
  }

}