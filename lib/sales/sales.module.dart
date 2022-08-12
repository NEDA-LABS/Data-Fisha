import 'package:flutter_modular/flutter_modular.dart';

import 'guards/acive-shop.guard.dart';
import 'pages/checkout.dart';
import 'pages/retail.dart';
import 'pages/index.dart';
import 'pages/wholesale.dart';
import 'states/cart.state.dart';
import 'states/sales.state.dart';

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
