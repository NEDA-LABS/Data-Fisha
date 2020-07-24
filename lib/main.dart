import 'dart:isolate';

import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';

import 'configurations.dart';
import 'modules/app/app.module.dart';
import 'package:smartstock_pos/services/sales_sync_service.dart';

void main() async {
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
  await Isolate.spawn(startServices ,"starting the services");
}

void startServices(String arg) async {
  var salesSyncService = SalesSyncService();
  salesSyncService.start();
}

void _connectWithBFastCloudProject() {
  BFast.init(AppCredentials('smartstock_lb', 'smartstock'));
  // BFast.int(AppCredentials('usJXSWzUGEmn', 'NBTnryqCyALq'));
}
