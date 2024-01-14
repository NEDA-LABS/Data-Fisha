import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';

class ReportIndexPage extends PageBase {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ReportIndexPage({
    required this.onBackPage,
    required this.onChangePage,
    Key? key,
  }) : super(key: key, pageName: 'ReportIndexPage');

  @override
  State<StatefulWidget> createState()=> _State();
}


class _State extends State<ReportIndexPage>{
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
        onClick: () => widget.onChangePage(OverviewCashSales(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Invoices overview',
        link: '/report/sales/overview/invoice',
        icon: Icons.receipt,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () =>
            widget.onChangePage(OverviewInvoiceSales(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Sales tracking',
        link: '/report/sales/track/cash',
        svgName: 'product_icon.svg',
        icon: Icons.receipt_long,
        roles: [],
        onClick: () =>
            widget.onChangePage(SalesCashTrackingPage(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Product performance',
        link: '/report/sales/performance/product',
        svgName: 'product_icon.svg',
        icon: Icons.trending_up,
        roles: [],
        onClick: () => widget.onChangePage(ProductPerformance(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Seller performance',
        link: '/report/sales/performance/seller',
        svgName: 'product_icon.svg',
        icon: Icons.supervisor_account_outlined,
        roles: [],
        onClick: () => widget.onChangePage(SellerPerformance(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Category overview',
        link: '/report/sales/performance/category',
        icon: Icons.category,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () =>
            widget.onChangePage(CategoryPerformance(onBackPage: widget.onBackPage)),
      ),
    ];
  }
}