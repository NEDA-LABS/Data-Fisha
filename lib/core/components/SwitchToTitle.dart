import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/HeadineMedium.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';

class SwitchToTitle extends StatelessWidget {
  const SwitchToTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(0, 16, 0, 8);
    const child = TitleMedium(text:"Switch to", );
    return const Padding(padding: padding, child: child);
  }
}
