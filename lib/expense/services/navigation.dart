import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/expense/pages/expenses.dart';
import 'package:smartstock/expense/pages/index.dart';

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

MenuModel expenseMenu(BuildContext context) => MenuModel(
      name: 'Expenses',
      icon: const Icon(Icons.receipt_long_rounded),
      link: '/expense/',
      onClick: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const ExpenseExpensesPage(),
                settings: const RouteSettings(name: 'r_expense')),
            (route) => route.settings.name != 'r_expense');
      },
      roles: ['*'],
      pages: _pagesMenu(),
    );
