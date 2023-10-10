import 'package:flutter/cupertino.dart';

class LabelSmall extends StatelessWidget {
  final String text;
  final TextOverflow? overflow;

  const LabelSmall(
      {Key? key, required this.text, this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.45,
        overflow: overflow,
      ),
    );
  }
}
