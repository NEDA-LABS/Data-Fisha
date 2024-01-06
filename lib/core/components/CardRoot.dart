import 'package:flutter/material.dart';

class CardRoot extends StatelessWidget {
  final Widget child;

  const CardRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
    );
    var padding = const EdgeInsets.all(16);
    return Container(padding: padding, decoration: decoration, child: child);
  }
}
