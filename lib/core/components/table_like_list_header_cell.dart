import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';

class TableLikeListHeaderCell extends StatelessWidget {
  final String name;

  const TableLikeListHeaderCell(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LabelLarge(text: name, overflow: TextOverflow.ellipsis),
    );
  }
}