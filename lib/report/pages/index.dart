import 'package:flutter/material.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';

class ReportIndexPage extends StatelessWidget {

  const ReportIndexPage({Key? key})
      : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/report/',
      sliverAppBar: getSliverSmartStockAppBar(
        title: "Report",
        showBack: false,
        context: context,
      ),
      staticChildren: [SwitchToPageMenu(pages: _pages(context))],
    );
  }

  List<ModulePageMenu> _pages(BuildContext context) {
    pageNav(Widget page) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    }

    return [
      ModulePageMenu(
        name: 'Cash overview',
        link: '/report/sales/overview/cash',
        svgName: 'product_icon.svg',
        icon: Icons.money,
        roles: [],
        onClick: () => pageNav(OverviewCashSales()),
      ),
      ModulePageMenu(
        name: 'Invoices overview',
        link: '/report/sales/overview/invoice',
        icon: Icons.receipt,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () => pageNav(OverviewInvoiceSales()),
      ),
      ModulePageMenu(
        name: 'Sales tracking',
        link: '/report/sales/track/cash',
        svgName: 'product_icon.svg',
        icon: Icons.receipt_long,
        roles: [],
        onClick: () => pageNav(SalesCashTrackingPage()),
      ),
      ModulePageMenu(
        name: 'Product performance',
        link: '/report/sales/performance/product',
        svgName: 'product_icon.svg',
        icon: Icons.trending_up,
        roles: [],
        onClick: () => pageNav(ProductPerformance()),
      ),
      ModulePageMenu(
        name: 'Seller performance',
        link: '/report/sales/performance/seller',
        svgName: 'product_icon.svg',
        icon: Icons.supervisor_account_outlined,
        roles: [],
        onClick: () => pageNav( SellerPerformance()),
      ),
      ModulePageMenu(
        name: 'Category overview',
        link: '/report/sales/performance/category',
        icon: Icons.category,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () => pageNav(CategoryPerformance()),
      ),
    ];
  }
}
