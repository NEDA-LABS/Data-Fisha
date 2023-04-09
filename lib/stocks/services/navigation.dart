import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/products.dart';
import 'package:smartstock/stocks/pages/purchases.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfers.dart';

import '../pages/index.dart';

List<SubMenuModule> _pages(BuildContext context) {
  pageNav(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  pageNameNav(String name) {
    Navigator.of(context).pushNamed(name);
  }

  return [
    SubMenuModule(
      name: 'Summary',
      link: '/stock/',
      roles: [],
      icon: Icons.summarize,
      svgName: 'product_icon.svg',
      onClick: () => pageNameNav('/stock'),
    ),
    SubMenuModule(
      name: 'Products',
      link: '/stock/products',
      roles: [],
      icon: Icons.sell,
      svgName: 'product_icon.svg',
      onClick: () => pageNav(const ProductsPage()),
    ),
    SubMenuModule(
      name: 'Categories',
      link: '/stock/categories',
      roles: [],
      icon: Icons.category,
      svgName: 'category_icon.svg',
      onClick: () => pageNav(const CategoriesPage()),
    ),
    SubMenuModule(
      name: 'Suppliers',
      link: '/stock/suppliers',
      roles: [],
      icon: Icons.support_agent_sharp,
      svgName: 'supplier_icon.svg',
      onClick: () => pageNav(const SuppliersPage()),
    ),
    SubMenuModule(
      name: 'Purchases',
      link: '/stock/purchases',
      roles: [],
      icon: Icons.receipt,
      svgName: 'invoice_icon.svg',
      onClick: () => pageNav(const PurchasesPage()),
    ),
    SubMenuModule(
      name: 'Transfer',
      link: '/stock/transfers',
      roles: [],
      icon: Icons.change_circle,
      svgName: 'transfer_icon.svg',
      onClick: () => pageNav(const TransfersPage()),
    ),
  ];
}

MenuModel getStocksModuleMenu(BuildContext context) {
  return MenuModel(
    name: 'Stocks',
    icon: const Icon(Icons.inventory),
    link: '/stock/',
    roles: ['admin', 'manager'],
    pages: _pages(context),
  );
}
