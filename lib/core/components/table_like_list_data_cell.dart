import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';

class TableLikeListTextDataCell extends StatelessWidget {
  final String name;

  const TableLikeListTextDataCell(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 14),
      child: BodyLarge(text: name),
    );
  }
}