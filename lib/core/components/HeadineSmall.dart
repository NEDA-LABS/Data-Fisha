import 'package:flutter/cupertino.dart';

class HeadlineSmall extends StatelessWidget{
  final String text;

  const HeadlineSmall({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 24,
          height: 1.33
      ),
    );
  }

}