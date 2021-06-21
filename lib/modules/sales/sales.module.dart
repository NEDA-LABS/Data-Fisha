import 'package:bfastui/adapters/child-module.adapter.dart';
import 'package:bfastui/adapters/router.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/sales/guards/acive-shop.guard.dart';
import 'package:smartstock_pos/modules/sales/pages/checkout.page.dart';
import 'package:smartstock_pos/modules/sales/pages/retail.page.dart';
import 'package:smartstock_pos/modules/sales/pages/sales.page.dart';
import 'package:smartstock_pos/modules/sales/pages/wholesale.page.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class SalesModule extends ChildModuleAdapter {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName)
        .addRoute(RouterAdapter(
          '/',
          guards: [ActiveShopGuard()],
          page: (context, args) => SalesPage(),
        ))
        .addRoute(RouterAdapter(
          '/whole',
          guards: [ActiveShopGuard()],
          page: (context, args) => WholesalePage(),
        ))
        .addRoute(RouterAdapter(
          '/retail',
          guards: [ActiveShopGuard()],
          page: (context, args) => RetailPage(),
        ))
        .addRoute(RouterAdapter(
          '/checkout/:type',
          guards: [ActiveShopGuard()],
          page: (context, args) => CheckoutPage(),
        ));
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName)
        .addState((_) => SalesState())
        .addState((_) => CartState());
  }

  @override
  String moduleName() {
    return 'sales';
  }
}
