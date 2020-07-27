import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';

import 'configurations.dart';
import 'modules/app/app.module.dart';
import 'modules/app/services/sales-sync.service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  _connectWithBFastCloudProject();
  runApp(
    BFastUI.module(SmartStockPos()).start(
      initialPath: '/shop',
      title: "SmartStock POS",
      theme: ThemeData(
        primarySwatch: Config.getSmartStockMaterialColorSwatch(),
      ),
    ),
  );
  // IsolateHandler().spawn(startSalesServices);
  // Isolate.spawn(startStockSyncServices, "starting stocks sync");

  startSalesServices(null);
}

void startSalesServices(Map args) {
  SalesSyncService().start();
}

void startStockSyncServices(String args) {
  StockSyncService().run();
}

void _connectWithBFastCloudProject() {
  BFast.init(AppCredentials('smartstock_lb', 'smartstock'));
}
