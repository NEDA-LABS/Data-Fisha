import 'package:flutter/cupertino.dart';

class LabelLarge extends StatelessWidget {
  final String text;
  final TextOverflow? overflow;

  const LabelLarge({Key? key, required this.text, this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.43,
          overflow: overflow,
      ),
    );
  }
}
