import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/DisplayTextMedium.dart';
import 'package:smartstock/core/components/LabelSmall.dart';

class EComBrand extends StatelessWidget{
  const EComBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DisplayTextMedium(text: "Haier"),
        LabelSmall(text: "Inspire living all around the world")
      ],
    );
  }

}