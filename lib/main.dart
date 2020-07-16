import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.module.dart';

import 'configurations.dart';

void main() {
  _connectWithBFastCloudProject();
  runApp(BFastUI.module(SmartStockPos()).start(
      initialPath: '/sales',
      title: "SmartStock",
      theme:
          ThemeData(primarySwatch: Config.getSmartStockMaterialColorSwatch())));
}

void _connectWithBFastCloudProject() {
  BFast.int(AppCredentials('smartstock_lb', 'smartstock'));
}
