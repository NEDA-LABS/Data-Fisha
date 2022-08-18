import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/models/menu.dart';
import 'package:smartstock_pos/core/services/util.dart';

drawer({String officeName, List<MenuModel> menus}) => Drawer(
      width: 250,
      child: modulesMenuContent(officeName, menus),
    );

modulesMenuContent(String name, List<MenuModel> menus) => SingleChildScrollView(
      child: Column(
        children: [_header(name), ...menus.map(_moduleMenuItems).toList()],
      ),
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
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.black),
      ),
    );

Widget _changeOfficeTextButton() => Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
            onPressed: () {},
            child: Text(
              'Change Office',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColor),
            )),
      ),
    );

Widget _moduleMenuItems(MenuModel item) => ExpansionTile(
      title: Text(
        item.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      children: [
        _subMenuItem(SubMenuModule(
            name: 'Summary',
            link: item.link,
            roles: item.roles,
            onClick: () {})),
        ...item.pages.map(_subMenuItem).toList()
      ],
    );

Widget _subMenuItem(SubMenuModule item) => GestureDetector(
      onTap: () => navigateTo(item.link),
      child: ListTile(
        trailing: const Icon(Icons.chevron_right),
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
