import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() => [
      SubMenuModule(
        name: 'Products',
        link: '/stock/products',
        roles: [],
        svgName: 'product_icon.svg',
        onClick: () {},
      ),
      // SubMenuModule(
      //   name: 'Item',
      //   link: '/stock/items',
      //   roles: [],
      //   svgName: 'item_icon.svg',
      //   onClick: () {},
      // ),
      SubMenuModule(
        name: 'Categories',
        link: '/stock/categories',
        roles: [],
        svgName: 'category_icon.svg',
        onClick: () {},
      ),
      // SubMenuModule(
      //   name: 'Units',
      //   link: '/stock/units',
      //   roles: [],
      //   svgName: 'unit_icon.svg',
      //   onClick: () {},
      // ),
      SubMenuModule(
        name: 'Suppliers',
        link: '/stock/suppliers',
        roles: [],
        svgName: 'supplier_icon.svg',
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Purchases',
        link: '/stock/purchases',
        roles: [],
        svgName: 'store_icon.svg',
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Transfer',
        link: '/stock/transfers',
        roles: [],
        svgName: 'transfer_icon.svg',
        onClick: () {},
      ),
    ];

MenuModel stocksMenu() => MenuModel(
      name: 'Stocks',
      icon: const Icon(Icons.inventory),
      link: '/stock/',
      roles: ['admin','manager'],
      pages: _pagesMenu(),
    );
