import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';

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
      onClick: () => pageNav(const SalesCashPage()),
    ),
    SubMenuModule(
      name: 'Invoices',
      link: '/sales/invoice',
      icon: Icons.receipt_long,
      svgName: 'invoice_icon.svg',
      roles: [],
      onClick: () => pageNav(const InvoicesPage()),
    ),
    SubMenuModule(
      name: 'Customers',
      link: '/sales/customers',
      svgName: 'customers_icon.svg',
      icon: Icons.supervised_user_circle_outlined,
      roles: [],
      onClick: () => pageNav(const CustomersPage()),
    ),
  ];
}

MenuModel getSalesModuleMenu(BuildContext context) => MenuModel(
      name: 'Sales',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      onClick: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => SalesPage(pages: _pagesMenu(context)),
              settings: const RouteSettings(name: 'r_sales')
            ),
            (route) => route.settings.name!='r_sales');
      },
      roles: ['*'],
      pages: _pagesMenu(context),
    );
