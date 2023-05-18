import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/responsive_body.dart';
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
final OnGetModulesMenu onGetModulesMenu;
  const StocksIndexPage({Key? key, required this.onGetModulesMenu}) : super(key: key);

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
      menus: onGetModulesMenu(context),
      sliverAppBar: appBar,
      staticChildren: [
        const SwitchToTitle(),
        SwitchToPageMenu(pages: _pages(context)),
        StocksSummary(onGetModulesMenu: onGetModulesMenu)
      ],
    );
  }

  List<SubMenuModule> _pages(BuildContext context) {
    pageNav(Widget page) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    }

    return [
      SubMenuModule(
        name: 'Inventories',
        link: '/stock/products',
        roles: [],
        icon: Icons.sell,
        svgName: 'product_icon.svg',
        onClick: () => pageNav(ProductsPage(onGetModulesMenu: onGetModulesMenu)),
      ),
      SubMenuModule(
        name: 'Categories',
        link: '/stock/categories',
        roles: [],
        icon: Icons.category,
        svgName: 'category_icon.svg',
        onClick: () => pageNav(CategoriesPage(onGetModulesMenu: onGetModulesMenu)),
      ),
      SubMenuModule(
        name: 'Suppliers',
        link: '/stock/suppliers',
        roles: [],
        icon: Icons.support_agent_sharp,
        svgName: 'supplier_icon.svg',
        onClick: () => pageNav(SuppliersPage(onGetModulesMenu: onGetModulesMenu)),
      ),
      SubMenuModule(
        name: 'Purchases',
        link: '/stock/purchases',
        roles: [],
        icon: Icons.receipt,
        svgName: 'invoice_icon.svg',
        onClick: () => pageNav(PurchasesPage(onGetModulesMenu: onGetModulesMenu)),
      ),
      SubMenuModule(
        name: 'Transfer',
        link: '/stock/transfers',
        roles: [],
        icon: Icons.change_circle,
        svgName: 'transfer_icon.svg',
        onClick: () => pageNav(TransfersPage(onGetModulesMenu: onGetModulesMenu,)),
      ),
    ];
  }
}
