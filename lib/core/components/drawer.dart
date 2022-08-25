import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/models/menu.dart';
import 'package:smartstock_pos/core/services/util.dart';

drawer(String office, List<MenuModel> menus, String current) => Drawer(
      width: 250,
      backgroundColor: Colors.white,
      child: modulesMenuContent(office, menus, current),
    );

modulesMenuContent(String name, List<MenuModel> menus, String current) =>
    ListView(
      controller: ScrollController(),
      children: [
        _header(name),
        ...menus.map(_moduleMenuItems(current)).toList()
      ],
    );

Widget _header(String currentOffice) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _officeName(currentOffice),
          _officeLogo(''),
          _changeOfficeTextButton()
        ],
      ),
    );

Widget _officeName(String name) => Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Theme.of(context).primaryColor),
        ),
      ),
    );

Widget _officeLogo(String url) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(builder: (context) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColor),
        );
      }),
    );

Widget _changeOfficeTextButton() => Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
            onPressed: () => navigateTo('/shop'),
            child: Text(
              'Change Office',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColor),
            )),
      ),
    );

_moduleMenuItems(String current) => (MenuModel item) => ExpansionTile(
      title: Text(
        item.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      initiallyExpanded: current == item.link,
      children: [
        _subMenuItem(SubMenuModule(
            name: 'Summary',
            link: item.link,
            roles: item.roles,
            onClick: () {})),
        ...item.pages.map(_subMenuItem).toList()
      ],
    );

Widget _subMenuItem(SubMenuModule item) => InkWell(
      onTap: () => navigateTo(item.link),
      child: ListTile(
        // trailing: const Icon(Icons.chevron_right),
        dense: true,
        title: Text(
          '        ${item.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
