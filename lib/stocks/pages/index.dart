import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/stock_summary.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/products.dart';
import 'package:smartstock/stocks/pages/purchases.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfers.dart';

class StocksIndexPage extends StatelessWidget {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const StocksIndexPage({
    Key? key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key);

  @override
  Widget build(context) {
    var appBar = getSliverSmartStockAppBar(
      title: "Stocks",
      showBack: false,
      context: context,
    );
    return ResponsivePage(
      office: '',
      current: '/stock/',
      sliverAppBar: appBar,
      staticChildren: [
        const SwitchToTitle(),
        SwitchToPageMenu(pages: _pages(context)),
        StocksSummary(
          onBackPage: onBackPage,
          onChangePage: onChangePage,
        )
      ],
    );
  }

  List<ModulePageMenu> _pages(BuildContext context) {
    return [
      ModulePageMenu(
        name: 'Inventories',
        link: '/stock/products',
        roles: [],
        icon: Icons.sell,
        svgName: 'product_icon.svg',
        onClick: () => onChangePage(
          ProductsPage(
            onBackPage: onBackPage,
            onChangePage: onChangePage,
          ),
        ),
      ),
      ModulePageMenu(
        name: 'Categories',
        link: '/stock/categories',
        roles: [],
        icon: Icons.category,
        svgName: 'category_icon.svg',
        onClick: () => onChangePage(
          CategoriesPage(
            onBackPage: onBackPage,
          ),
        ),
      ),
      ModulePageMenu(
        name: 'Suppliers',
        link: '/stock/suppliers',
        roles: [],
        icon: Icons.support_agent_sharp,
        svgName: 'supplier_icon.svg',
        onClick: () => onChangePage(
          SuppliersPage(
            onBackPage: onBackPage,
          ),
        ),
      ),
      ModulePageMenu(
        name: 'Purchases',
        link: '/stock/purchases',
        roles: [],
        icon: Icons.receipt,
        svgName: 'invoice_icon.svg',
        onClick: () => onChangePage(
          PurchasesPage(
            onBackPage: onBackPage,
            onChangePage: onChangePage,
          ),
        ),
      ),
      ModulePageMenu(
        name: 'Transfer',
        link: '/stock/transfers',
        roles: [],
        icon: Icons.change_circle,
        svgName: 'transfer_icon.svg',
        onClick: () => onChangePage(
          TransfersPage(
            onBackPage: onBackPage,
            onChangePage: onChangePage,
          ),
        ),
      ),
    ];
  }
}
