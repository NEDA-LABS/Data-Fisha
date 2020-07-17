import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:bfastui/controllers/state.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/modules/account/states/login.state.dart';
import 'package:smartstock/modules/sales/guard/AuthGuard.dart';
import 'package:smartstock/modules/sales/pages/retail.page.dart';
import 'package:smartstock/modules/sales/pages/sales.page.dart';
import 'package:smartstock/modules/sales/pages/wholesale.page.dart';
import 'package:smartstock/modules/sales/states/sales.state.dart';

class SalesModule extends BFastUIChildModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName)
        .addRoute(
          BFastUIRouter(
            '/',
            guards: [AuthGuard()],
            onGuardCheck: Container(
              color: Colors.white,
            ),
            page: (context, args) => SalesPage(),
          ),
        )
        .addRoute(BFastUIRouter(
          '/whole',
          guards: [AuthGuard()],
          onGuardCheck: Container(
            color: Colors.white,
          ),
          page: (context, args) => WholesalePage(),
        ))
        .addRoute(BFastUIRouter(
          '/retail',
          guards: [AuthGuard()],
          onGuardCheck: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: CircularProgressIndicator(),
          ),
          page: (context, args) => RetailPage(),
        ));
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName)
        .addState(BFastUIStateBinder((_) => LoginPageState()))
        .addState(BFastUIStateBinder((_) => SalesState()));
        
  }

  @override
  String moduleName() {
    return 'sales';
  }
}
