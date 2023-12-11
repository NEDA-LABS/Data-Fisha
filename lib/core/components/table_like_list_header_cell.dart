import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';

class TableLikeListHeaderCell extends StatelessWidget {
  final String name;
  final double horizontal;

  const TableLikeListHeaderCell(this.name, {Key? key, this.horizontal=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: horizontal),
      child: LabelLarge(text: name, overflow: TextOverflow.ellipsis),
    );
  }
}