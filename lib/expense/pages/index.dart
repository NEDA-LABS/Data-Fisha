import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/dashboard/components/dashboard_summary.dart';

class ExpenseIndexPage extends StatelessWidget {
  const ExpenseIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return responsiveBody(
      office: 'Menu',
      current: '/expense/',
      menus: moduleMenus(),
      onBody: (d) => Scaffold(
        drawer: d,
        appBar: StockAppBar(title: "Expense", showBack: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 790),
              child: Container(),
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(3, moduleMenus(), context),
      ),
    );
  }
}
