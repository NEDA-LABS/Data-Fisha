import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() {
  return [
    SubMenuModule(
      name: 'Profile',
      link: '/account/profile',
      svgName: 'item_icon.svg',
      roles: [],
      onClick: () {},
    ),
    SubMenuModule(
      name: 'Users',
      link: '/account/users',
      svgName: 'item_icon.svg',
      roles: [],
      onClick: () {},
    )
  ];
}

MenuModel accountMenu() {
  return MenuModel(
    name: 'Account',
    icon: const Icon(Icons.supervised_user_circle),
    link: '/account/',
    roles: [],
    pages: _pagesMenu(),
  );
}
