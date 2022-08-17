import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app.dart';
import 'configurations.dart';
import 'sales/services/sales_sync.dart';
import 'sales/services/stocks.dart';

void main() async {
  // Modular.setInitialRoute('/shop');
  Builders.systemInjector(Modular.get);
  runApp(
    ModularApp(
      module: AppModule(),
      child: MaterialApp.router(
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: getSmartStockMaterialColorSwatch(),
        ),
      ),
    ),
  );
  SalesSyncService().start();
  StockSyncService.run();
}
