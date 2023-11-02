import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';

class EComInfoRibbon extends StatelessWidget{
  const EComInfoRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary
      ),
      child: Row(
        children: [
          LabelLarge(text: "Reasons to shop", color: Theme.of(context).colorScheme.onPrimary,),
          WhiteSpacer(width: 8),
          Expanded(child: Container()),
          LabelLarge(text: '+255766777666',color: Theme.of(context).colorScheme.onPrimary,)
        ],
      ),
    );
  }

}