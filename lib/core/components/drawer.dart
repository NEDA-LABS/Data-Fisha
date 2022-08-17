import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/models/menu.dart';

import '../models/shop.dart';

drawer(ShopModel shop) => (List<MenuModel> menus) => Drawer(
      width: 250,
      child: Column(
        children: [_header(shop), ...menus.map(_moduleMenuItems)],
      ),
    );

Widget _header(ShopModel shop) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _officeName(shop.businessName),
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
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
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
      title: Padding(
        padding: const EdgeInsets.fromLTRB(23, 13, 8, 13),
        child: Text(
          item.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      children: item.pages.map(_subMenuItem),
    );

Widget _subMenuItem(SubMenuModule item) => Container(child: Text(item.name));
