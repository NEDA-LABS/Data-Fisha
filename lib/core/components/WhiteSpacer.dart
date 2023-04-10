import 'package:flutter/material.dart';

class WhiteSpacer extends StatelessWidget {
  final double height;
  final double width;

  const WhiteSpacer({Key? key, this.width = 0.0, this.height = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
