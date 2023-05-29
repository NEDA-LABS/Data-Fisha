import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

class ExpenseIndexPage extends StatelessWidget {
  const ExpenseIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/expense/',
      sliverAppBar:
          getSliverSmartStockAppBar(title: "Expense", showBack: false, context: context),
      staticChildren: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 790),
              child: Container(),
            ),
          ),
        )
      ],
    );
  }

  List<ModulePageMenu> _pagesMenu() => [
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

}
