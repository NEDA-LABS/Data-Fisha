import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() => [
      SubMenuModule(
        name: 'Retail',
        link: '/sales/retail',
        roles: [],
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Whole',
        link: '/sales/whole',
        roles: [],
        onClick: () {},
      ),
    ];

MenuModel salesMenu() => MenuModel(
      name: 'Sales',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      roles: [],
      pages: _pagesMenu(),
    );
