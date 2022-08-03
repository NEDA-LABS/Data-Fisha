import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'configurations.dart';
import 'modules/app/app.module.dart';
import 'modules/sales/services/sales-sync.service.dart';
import 'modules/sales/services/stocks.service.dart';

void main() async {
  _connectWithBFastCloudProject();
  Modular.setInitialRoute('/shop/');
  Builders.systemInjector(Modular.get);
  runApp(
    ModularApp(
      module: AppModule(),
      child: MaterialApp.router(
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Config.getSmartStockMaterialColorSwatch(),
        ),
      ),
    ),
  );
  startSalesServices();
  startStockSyncServices();
}

void startSalesServices() {
  SalesSyncService().start();
}

void startStockSyncServices() {
  StockSyncService.run();
}

void _connectWithBFastCloudProject() {
  BFast.init(AppCredentials('smartstock_lb', 'smartstock'));
}
