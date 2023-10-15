import 'package:flutter/material.dart';

class TableLikeListRow extends StatelessWidget {
  final List<Widget> items;

  const TableLikeListRow(this.items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mapFn(e) => Expanded(flex: items.indexOf(e) == 0 ? 2 : 1, child: e);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(children: items.map(mapFn).toList()),
    );
  }
}
