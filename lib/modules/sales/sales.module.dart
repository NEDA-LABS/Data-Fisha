import 'package:bfastui/adapters/child_module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock_pos/modules/sales/guards/acive-shop.guard.dart';
import 'package:smartstock_pos/modules/sales/pages/checkout.page.dart';
import 'package:smartstock_pos/modules/sales/pages/retail.page.dart';
import 'package:smartstock_pos/modules/sales/pages/sales.page.dart';
import 'package:smartstock_pos/modules/sales/pages/wholesale.page.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class SalesModule extends ChildModuleAdapter {
  @override
  List<RouterAdapter> initRoutes(String moduleName) => [
    RouterAdapter(
      '/',
      guards: [ActiveShopGuard()],
      page: (context, args) => SalesPage(),
    ),
    RouterAdapter(
      '/whole',
      guards: [ActiveShopGuard()],
      page: (context, args) => WholesalePage(),
    ),
    RouterAdapter(
      '/retail',
      guards: [ActiveShopGuard()],
      page: (context, args) => RetailPage(),
    ),
    RouterAdapter(
      '/checkout/:type',
      guards: [ActiveShopGuard()],
      page: (context, args) => CheckoutPage(),
    )
  ];

  @override
  List<StateAdapter> initStates(String moduleName) => [
    SalesState(),
    CartState()
  ];

  @override
  String moduleName() => 'sales';
}
