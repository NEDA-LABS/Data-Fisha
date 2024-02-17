import 'package:flutter/material.dart';

class TableLikeListRow extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsets? padding;
  final bool withBorder;

  const TableLikeListRow(this.items,
      {super.key, this.padding, this.withBorder = false});

  @override
  Widget build(BuildContext context) {
    mapFn(e) => Expanded(flex: items.indexOf(e) == 0 ? 2 : 1, child: e);
    return Padding(
      padding: padding ?? const EdgeInsets.all(8),
      child: Row(mainAxisSize: MainAxisSize.min,children: items.map(mapFn).toList(),),
    );
  }
}
