import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

_iconContainer(String svg) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Builder(
        builder: (context) => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColorDark),
          child: SvgPicture.asset(
            'assets/svg/$svg',
            width: 24,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );

_name(String name) => Padding(
    padding: const EdgeInsets.all(5),
    child: Text(
      name,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    ));

Widget _switchToItem(SubMenuModule menu) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: GestureDetector(
        onTap: () => navigateTo(menu.link),
        child: Column(
          children: [_iconContainer(menu.svgName), _name(menu.name)],
        ),
      ),
    );

switchToItems(List<SubMenuModule> menus) =>
    menus.map<Widget>(_switchToItem).toList();
