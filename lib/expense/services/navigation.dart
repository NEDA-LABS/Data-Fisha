import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() => [
      // SubMenuModule(
      //   name: 'Categories',
      //   link: '/expense/categories',
      //   svgName: 'product_icon.svg',
      //   roles: ['admin', 'manager'],
      //   onClick: () {},
      // ),
      // SubMenuModule(
      //   name: 'Items',
      //   link: '/expense/items',
      //   svgName: 'product_icon.svg',
      //   roles: ['admin', 'manager'],
      //   onClick: () {},
      // ),
      // SubMenuModule(
      //   name: 'Expenses',
      //   link: '/expense/expenses',
      //   svgName: 'product_icon.svg',
      //   roles: ['admin', 'manager'],
      //   onClick: () {},
      // ),
    ];

MenuModel expenseMenu() => MenuModel(
      name: 'Expenses',
      icon: const Icon(Icons.receipt_long_rounded),
      link: '/expense/',
      roles: ['*'],
      pages: _pagesMenu(),
    );
