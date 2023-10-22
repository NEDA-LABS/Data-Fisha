import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 0.5, thickness: 0.5);
    //Container(height: 0.1, color: Theme.of(context).colorScheme.onSurfaceVariant);
  }
}
