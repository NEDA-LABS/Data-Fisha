import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:bfastui/controllers/state.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/states/shop_details.dart';

import 'configurations.dart';
import 'modules/dashboard/dashboard.page.dart';

void main() {
  _registerStates();
  _registerRoutes();
  runApp(BFastUI.module(
          title: "SmartStock",
          theme: ThemeData(
              primarySwatch: Config.getSmartStockMaterialColorSwatch()))
      .start());
}

void _registerStates() {
  // dashboard module state
  BFastUI.states(moduleName: 'dashboard').addState(
    BFastUIStateBinder((_) => ShopDetailsState()),
  );
}

void _registerRoutes() {
  // main routes
  BFastUI.navigation().addRoute(
    BFastUIRouter(
      '/',
      module: BFastUI.childModule('dashboard'),
    ),
  );
  // dashboard module routes
  BFastUI.navigation(moduleName: 'dashboard').addRoute(
    BFastUIRouter(
      '/',
      page: (context, args) => DashBoardPage(),
    ),
  );
}
