import 'package:flutter/material.dart';

class TableLikeListRow extends StatelessWidget {
  final List<Widget> items;
  final double padding;
  final bool withBorder;

  const TableLikeListRow(this.items,
      {super.key, this.padding = 8, this.withBorder = false});

  @override
  Widget build(BuildContext context) {
    mapFn(e) => Expanded(flex: items.indexOf(e) == 0 ? 2 : 1, child: e);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(children: items.map(mapFn).toList()),
    );
  }
}
