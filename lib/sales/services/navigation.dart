import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/models/menu.dart';

List<SubMenuModule> _pagesMenu() => [
      SubMenuModule(
        name: 'Retail',
        link: '/sales/retail',
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Wholesale',
        link: '/sales/whole',
        svgName: 'supplier_icon.svg',
        roles: [],
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Invoices',
        link: '/sales/invoice',
        svgName: 'invoice_icon.svg',
        roles: [],
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Customers',
        link: '/sales/customers',
        svgName: 'customers_icon.svg',
        roles: [],
        onClick: () {},
      ),
      SubMenuModule(
        name: 'Refunds',
        link: '/sales/refund',
        svgName: 'transfer_icon.svg',
        roles: [],
        onClick: () {},
      )
    ];

MenuModel salesMenu() => MenuModel(
      name: 'Sales',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      roles: [],
      pages: _pagesMenu(),
    );
