import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() => [
  // SubMenuModule(
  //   name: 'Cash sale',
  //   link: '/dashboards/cash',
  //   svgName: 'product_icon.svg',
  //   roles: [],
  //   onClick: () {},
  // )
];

MenuModel dashboardMenu() => MenuModel(
  name: 'Dashboard',
  icon: const Icon(Icons.dashboard),
  link: '/dashboard/',
  roles: [],
  pages: _pagesMenu(),
);
