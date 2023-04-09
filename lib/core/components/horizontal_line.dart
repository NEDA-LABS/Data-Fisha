import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget{
  const HorizontalLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(height: 0.8, color: Theme.of(context).colorScheme.surfaceVariant);
  }

}
