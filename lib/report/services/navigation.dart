import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';

List<SubMenuModule> _pages(BuildContext context) {
  pageNav(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  return [
    SubMenuModule(
      name: 'Cash overview',
      link: '/report/sales/overview/cash',
      svgName: 'product_icon.svg',
      icon: Icons.money,
      roles: [],
      onClick: () => pageNav(const OverviewCashSales()),
    ),
    SubMenuModule(
      name: 'Invoices overview',
      link: '/report/sales/overview/invoice',
      icon: Icons.receipt,
      svgName: 'product_icon.svg',
      roles: [],
      onClick: () => pageNav(const OverviewInvoiceSales()),
    ),
    SubMenuModule(
      name: 'Sales tracking',
      link: '/report/sales/track/cash',
      svgName: 'product_icon.svg',
      icon: Icons.receipt_long,
      roles: [],
      onClick: () => pageNav(const SalesCashTrackingPage()),
    ),
    SubMenuModule(
      name: 'Product performance',
      link: '/report/sales/performance/product',
      svgName: 'product_icon.svg',
      icon: Icons.trending_up,
      roles: [],
      onClick: () => pageNav(const ProductPerformance()),
    ),
    SubMenuModule(
      name: 'Seller performance',
      link: '/report/sales/performance/seller',
      svgName: 'product_icon.svg',
      icon: Icons.supervisor_account_outlined,
      roles: [],
      onClick: () => pageNav(const SellerPerformance()),
    ),
    SubMenuModule(
      name: 'Category overview',
      link: '/report/sales/performance/category',
      icon: Icons.category,
      svgName: 'product_icon.svg',
      roles: [],
      onClick: () => pageNav(const CategoryPerformance()),
    ),
  ];
}

MenuModel reportMenu(BuildContext context) => MenuModel(
      name: 'Reports',
      icon: const Icon(Icons.data_saver_off),
      link: '/report/',
      onClick: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ReportIndexPage(),
          settings: const RouteSettings(name: 'r_reports'),
        ),
        (route) {
          return route.settings.name != 'r_reports';
        },
      ),
      roles: ['admin'],
      pages: _pages(context),
    );
