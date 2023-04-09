import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TitleLarge.dart';

class SwitchToTitle extends StatelessWidget {
  const SwitchToTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(0, 16, 0, 8);
    const child = TitleLarge(text:"Switch to");
    return const Padding(padding: padding, child: child);
  }
}
