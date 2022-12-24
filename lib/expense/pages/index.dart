import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';

class ExpenseIndexPage extends StatelessWidget {
  const ExpenseIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/expense/',
      menus: moduleMenus(),
      sliverAppBar:
          StockAppBar(title: "Expense", showBack: false, context: context),
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
}
