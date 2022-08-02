import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/modules/sales/guards/acive-shop.guard.dart';
import 'package:smartstock_pos/modules/sales/pages/checkout.page.dart';
import 'package:smartstock_pos/modules/sales/pages/retail.page.dart';
import 'package:smartstock_pos/modules/sales/pages/sales.page.dart';
import 'package:smartstock_pos/modules/sales/pages/wholesale.page.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class SalesModule extends Module {
  @override
  List<ChildRoute> get routes => [
    ChildRoute(
      '/',
      guards: [ActiveShopGuard()],
      child: (_, __) => SalesPage(),
    ),
    ChildRoute(
      '/whole',
      guards: [ActiveShopGuard()],
      child: (context, args) => WholesalePage(),
    ),
    ChildRoute(
      '/retail',
      guards: [ActiveShopGuard()],
      child: (context, args) => RetailPage(),
    ),
    ChildRoute(
      '/checkout/:type',
      guards: [ActiveShopGuard()],
      child: (context, args) => CheckoutPage(args),
    )
  ];

  @override
  List<Bind> get binds => [
    Bind.lazySingleton((i) => SalesState()),
    Bind.lazySingleton((i) => CartState())
  ];
}
