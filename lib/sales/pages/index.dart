import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/index_page.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/switch_to_item.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/sales/services/navigation.dart';

class SalesPage extends StatelessWidget {

  const SalesPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/sales/',
      menus: moduleMenus(),
      staticChildren: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 790),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  switchToTitle(),
                  Wrap(children: switchToItems(salesMenu().pages)),
                  // salesSummary(),
                ],
              ),
            ),
          ),
        )
      ],
      sliverAppBar: StockAppBar(title: "Sales", showBack: false, context: context),
      // onBody: (x) => Scaffold(
      //   drawer: x,
      //   body: ,
      //   bottomNavigationBar: bottomBar(1, moduleMenus(), context),
      // ),
    );
  }
}
