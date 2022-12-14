import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/states/sales_external_services.dart';

List<SubMenuModule> _pagesMenu() => [
      // SubMenuModule(
      //   name: 'Home',
      //   link: '/sales/',
      //   svgName: 'product_icon.svg',
      //   roles: [],
      //   onClick: () {},
      // ),
      SubMenuModule(
        name: 'Cash sale',
        link: '/sales/cash',
        svgName: 'product_icon.svg',
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
    ];

MenuModel salesMenu() => MenuModel(
      name: 'Sales',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      roles: ['*'],
      pages: [
        ..._pagesMenu(),
        ...SalesExternalServiceState()
            .salesExternalServices
            .map<SubMenuModule>((e) {
          return SubMenuModule(
            name: e.name,
            link: '/sales${e.pageLink}',
            svgName: null,
            // 'transfer_icon.svg',
            icon: e.icon,
            roles: [],
            onClick: () {},
          );
        })
      ],
    );
