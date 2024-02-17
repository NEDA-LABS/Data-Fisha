import 'package:flutter/material.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/models/menu.dart';

_contextButton({required String text, required Function? pressed}){
  return MenuContextAction(
    onPressed: pressed as void Function()?,
    title: text,
  );
}

_items(items){
  return SizedBox(
    height: 62,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
      child: Wrap(
        // scrollDirection: Axis.horizontal,
        children: [
          ...items
              .map((e) => _contextButton(text: e.name, pressed: e.pressed)),
        ],
      ),
    ),
  );
}

getTableContextMenu(List<ContextMenu> items){
  return _items(items);
}
