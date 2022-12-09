import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() => [
  SubMenuModule(
    name: 'Cash sales overview',
    link: '/report/sales/overview/cash',
    svgName: 'product_icon.svg',
    roles: [],
    onClick: () {},
  ),
  // SubMenuModule(
  //   name: 'Monthly cash sales',
  //   link: '/report/sales/overview/cash/month',
  //   svgName: 'product_icon.svg',
  //   roles: [],
  //   onClick: () {},
  // ),
  // SubMenuModule(
  //   name: 'Yearly cash sales',
  //   link: '/report/sales/overview/cash/year',
  //   svgName: 'product_icon.svg',
  //   roles: [],
  //   onClick: () {},
  // ),
  SubMenuModule(
    name: 'Invoice sales overview',
    link: '/report/sales/overview/invoice',
    svgName: 'product_icon.svg',
    roles: [],
    onClick: () {},
  ),
  // SubMenuModule(
  //   name: 'Monthly invoice sales',
  //   link: '/report/sales/overview/invoice/month',
  //   svgName: 'product_icon.svg',
  //   roles: [],
  //   onClick: () {},
  // ),
  // SubMenuModule(
  //   name: 'Yearly invoice sales',
  //   link: '/report/sales/overview/invoice/year',
  //   svgName: 'product_icon.svg',
  //   roles: [],
  //   onClick: () {},
  // ),
  SubMenuModule(
    name: 'Cash sales tracking',
    link: '/report/sales/track/cash',
    svgName: 'product_icon.svg',
    roles: [],
    onClick: () {},
  ),
  SubMenuModule(
    name: 'Product performance',
    link: '/report/sales/performance/product',
    svgName: 'product_icon.svg',
    roles: [],
    onClick: () {},
  ),
  SubMenuModule(
    name: 'Seller performance',
    link: '/report/sales/performance/seller',
    svgName: 'product_icon.svg',
    roles: [],
    onClick: () {},
  ),
  SubMenuModule(
    name: 'Category performance',
    link: '/report/sales/performance/category',
    svgName: 'product_icon.svg',
    roles: [],
    onClick: () {},
  ),
];

MenuModel reportMenu() => MenuModel(
  name: 'Reports',
  icon: const Icon(Icons.trending_up),
  link: '/report/',
  roles: ['admin'],
  pages: _pagesMenu(),
);
