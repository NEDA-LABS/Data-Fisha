import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';

class ReportIndexPage extends StatelessWidget {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ReportIndexPage({
    required this.onBackPage,
    required this.onChangePage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/report/',
      sliverAppBar: SliverSmartStockAppBar(
        title: "Report",
        showBack: false,
        context: context,
      ),
      staticChildren: [SwitchToPageMenu(pages: _pages(context))],
    );
  }

  List<ModulePageMenu> _pages(BuildContext context) {
    return [
      ModulePageMenu(
        name: 'Cash overview',
        link: '/report/sales/overview/cash',
        svgName: 'product_icon.svg',
        icon: Icons.money,
        roles: [],
        onClick: () => onChangePage(OverviewCashSales(onBackPage: onBackPage)),
      ),
      ModulePageMenu(
        name: 'Invoices overview',
        link: '/report/sales/overview/invoice',
        icon: Icons.receipt,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () =>
            onChangePage(OverviewInvoiceSales(onBackPage: onBackPage)),
      ),
      ModulePageMenu(
        name: 'Sales tracking',
        link: '/report/sales/track/cash',
        svgName: 'product_icon.svg',
        icon: Icons.receipt_long,
        roles: [],
        onClick: () =>
            onChangePage(SalesCashTrackingPage(onBackPage: onBackPage)),
      ),
      ModulePageMenu(
        name: 'Product performance',
        link: '/report/sales/performance/product',
        svgName: 'product_icon.svg',
        icon: Icons.trending_up,
        roles: [],
        onClick: () => onChangePage(ProductPerformance(onBackPage: onBackPage)),
      ),
      ModulePageMenu(
        name: 'Seller performance',
        link: '/report/sales/performance/seller',
        svgName: 'product_icon.svg',
        icon: Icons.supervisor_account_outlined,
        roles: [],
        onClick: () => onChangePage(SellerPerformance(onBackPage: onBackPage)),
      ),
      ModulePageMenu(
        name: 'Category overview',
        link: '/report/sales/performance/category',
        icon: Icons.category,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () =>
            onChangePage(CategoryPerformance(onBackPage: onBackPage)),
      ),
    ];
  }
}
