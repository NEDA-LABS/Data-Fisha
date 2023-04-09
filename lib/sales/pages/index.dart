import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';

import '../../core/models/menu.dart';

class SalesPage extends StatelessWidget {
  final List<SubMenuModule> pages;

  const SalesPage({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/sales/',
      menus: getAppModuleMenus(context),
      staticChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const SwitchToTitle(), SwitchToPageMenu(pages: pages)],
        )
      ],
      sliverAppBar: getSliverSmartStockAppBar(
          title: "Sales", showBack: false, context: context),
      // onBody: (x) => Scaffold(
      //   drawer: x,
      //   body: ,
      //   bottomNavigationBar: bottomBar(1, moduleMenus(), context),
      // ),
    );
  }
}
