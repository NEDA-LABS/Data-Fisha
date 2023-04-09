import 'package:flutter/cupertino.dart';

class TitleMedium extends StatelessWidget{
  final String text;

  const TitleMedium({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.5,
      ),
    );
  }

}