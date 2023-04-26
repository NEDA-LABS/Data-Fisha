import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/report/services/navigation.dart';

class ReportIndexPage extends StatelessWidget {
  const ReportIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) => ResponsivePage(
        office: 'Menu',
        current: '/report/',
        menus: getAppModuleMenus(context),
        sliverAppBar: getSliverSmartStockAppBar(
            title: "Report", showBack: false, context: context),
        staticChildren: [
          SwitchToPageMenu(pages: reportMenu(context).pages),
        ],
      );
}
