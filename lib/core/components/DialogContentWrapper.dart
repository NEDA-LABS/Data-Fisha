import 'package:flutter/material.dart';

class DialogContentWrapper extends StatelessWidget {
  final Widget child;

  const DialogContentWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
        minHeight: 300,
        maxHeight: 600,
      ),
      child: child,
    );
  }
}
