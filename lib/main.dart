import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';

import 'configurations.dart';
import 'modules/app/app.module.dart';
import 'modules/sales/services/sales-sync.service.dart';
import 'modules/sales/services/stocks.service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  _connectWithBFastCloudProject();
  runApp(
    BFastUI.module(SmartStockPos()).start(
      initialPath: '/shop',
      title: "SmartStock POS",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Config.getSmartStockMaterialColorSwatch(),
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
