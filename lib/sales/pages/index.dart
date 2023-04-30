import 'package:flutter/material.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';

import '../../core/models/menu.dart';
import 'customers.dart';

class SalesPage extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const SalesPage({Key? key, required this.onGetModulesMenu}) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/sales/',
      menus: onGetModulesMenu(context),
      staticChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SwitchToTitle(),
            SwitchToPageMenu(pages: _pagesMenu(context))
          ],
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

  List<SubMenuModule> _pagesMenu(BuildContext context) {
    pageNav(Widget page) {
      return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => page,
      ));
    }

    return [
      SubMenuModule(
        name: 'Cash sale',
        link: '/sales/cash',
        icon: Icons.storefront_sharp,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () => pageNav(SalesCashPage(onGetModulesMenu: onGetModulesMenu,)),
      ),
      SubMenuModule(
        name: 'Invoices',
        link: '/sales/invoice',
        icon: Icons.receipt_long,
        svgName: 'invoice_icon.svg',
        roles: [],
        onClick: () => pageNav( InvoicesPage(onGetModulesMenu: onGetModulesMenu,)),
      ),
      SubMenuModule(
        name: 'Customers',
        link: '/sales/customers',
        svgName: 'customers_icon.svg',
        icon: Icons.supervised_user_circle_outlined,
        roles: [],
        onClick: () =>
            pageNav(CustomersPage(onGetModulesMenu: onGetModulesMenu)),
      ),
    ];
  }
}
