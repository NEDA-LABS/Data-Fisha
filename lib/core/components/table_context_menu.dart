import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';

_contextButton({@required String text, @required Function pressed}) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
    child: OutlinedButton(onPressed: pressed, child: Text(text)));

_items(items) => SizedBox(
    height: 62,
    child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          ...items.map((e) => _contextButton(text: e.name, pressed: e.pressed)),
        ])));

tableContextMenu(List<ContextMenu> items) =>
    Column(children: [_items(items), const Divider(height: 2)]);
