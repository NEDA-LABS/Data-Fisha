import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';

class TableLikeListTextDataCell extends StatelessWidget {
  final String name;
  final double verticalPadding;
  final TextAlign? textAlign;

  const TableLikeListTextDataCell(this.name, {super.key, this.verticalPadding=14, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: verticalPadding),
      child: BodyLarge(text: name,textAlign: textAlign),
    );
  }
}