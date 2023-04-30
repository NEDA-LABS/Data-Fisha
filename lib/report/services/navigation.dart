import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';

MenuModel reportMenu(BuildContext context){
  return MenuModel(
    name: 'Reports',
    icon: const Icon(Icons.data_saver_off),
    link: '/report/',
    // onClick: () => Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => const ReportIndexPage(),
    //     settings: const RouteSettings(name: 'r_reports'),
    //   ),
    //       (route) {
    //     return route.settings.name != 'r_reports';
    //   },
    // ),
    roles: ['admin'],
  );
}
