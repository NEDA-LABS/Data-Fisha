import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';

import 'configurations.dart';
import 'modules/app/app.module.dart';

void main() {
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
}

void _connectWithBFastCloudProject() {
  BFast.int(AppCredentials('smartstock_lb', 'smartstock'));
  // BFast.int(AppCredentials('usJXSWzUGEmn', 'NBTnryqCyALq'));
}
