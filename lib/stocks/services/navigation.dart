import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/products.dart';
import 'package:smartstock/stocks/pages/purchases.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfers.dart';

import '../pages/index.dart';

MenuModel getStocksModuleMenu(BuildContext context) {
  return MenuModel(
    name: 'Stocks',
    icon: const Icon(Icons.inventory),
    link: '/stock/',
    // onClick: () {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => StocksIndexPage(pages: _pages(context)),
    //       settings: const RouteSettings(name: 'r_stocks'),
    //     ),
    //     (route) => route.settings.name != 'r_stocks',
    //   );
    // },
    roles: ['admin', 'manager'],
  );
}
