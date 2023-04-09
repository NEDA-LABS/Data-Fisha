import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/models/menu.dart';

_contextButton({required String text, required Function? pressed}) => Padding(
    padding: const EdgeInsets.all(0),
    child: outlineActionButton(onPressed: pressed as void Function()?, title: text));

_items(items) => SizedBox(
    height: 62,
    child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          ...items.map((e) => _contextButton(text: e.name, pressed: e.pressed)),
        ])));

tableContextMenu(List<ContextMenu> items) =>
    Column(children: [_items(items), HorizontalLine()]);
