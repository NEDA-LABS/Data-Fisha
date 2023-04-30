import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';

MenuModel getSalesModuleMenu(BuildContext context) => MenuModel(
      name: 'Point Of Sale',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      // onClick: () {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(
      //         builder: (context) => SalesPage(pages: _pagesMenu(context)),
      //         settings: const RouteSettings(name: 'r_sales')
      //       ),
      //       (route) => route.settings.name!='r_sales');
      // },
      roles: ['*'],
    );
