import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/sales/guards/acive-shop.guard.dart';
import 'package:smartstock_pos/modules/sales/pages/retail.page.dart';
import 'package:smartstock_pos/modules/sales/pages/sales.page.dart';
import 'package:smartstock_pos/modules/sales/pages/wholesale.page.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class SalesModule extends BFastUIChildModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName)
        .addRoute(BFastUIRouter(
          '/',
          guards: [ActiveShopGuard()],
          page: (context, args) => SalesPage(),
        ))
        .addRoute(BFastUIRouter(
          '/whole',
          guards: [ActiveShopGuard()],
          page: (context, args) => WholesalePage(),
        ))
        .addRoute(BFastUIRouter(
          '/retail',
          guards: [ActiveShopGuard()],
          page: (context, args) => RetailPage(),
        ));
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName)
        .addState((_) => SalesState())
        .addState((i) => CartState());
  }

  @override
  String moduleName() {
    return 'sales';
  }
}
