import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/stocks/components/stock_summary.dart';

class StocksIndexPage extends StatelessWidget {
  final List<SubMenuModule> pages;

  const StocksIndexPage({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(context) {
    var appBar = getSliverSmartStockAppBar(
      title: "Stocks",
      showBack: false,
      context: context,
    );
    var pagesWithNoIndex =
        pages.where((element) => element.name != 'Summary').toList();

    return ResponsivePage(
      office: '',
      current: '/stock/',
      menus: getAppModuleMenus(context),
      sliverAppBar: appBar,
      staticChildren: [
        const SwitchToTitle(),
        SwitchToPageMenu(pages: pagesWithNoIndex),
        const StocksSummary()
      ],
    );
  }
}
