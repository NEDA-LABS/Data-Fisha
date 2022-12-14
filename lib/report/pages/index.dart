import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/index_page.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/switch_to_item.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/report/services/navigation.dart';


class ReportIndexPage extends StatelessWidget {
  const ReportIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) => ResponsivePage(
      office: 'Menu',
      current: '/report/',
      menus: moduleMenus(),
      sliverAppBar: StockAppBar(title: "Report", showBack: false, context: context),
      onBody: (x) => Scaffold(
        drawer: x,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 790),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  switchToTitle(),
                  Wrap(children: switchToItems(reportMenu().pages)),
                  // salesSummary(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(3, moduleMenus(), context),
      ));
}
