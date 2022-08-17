import 'package:flutter_modular/flutter_modular.dart';

import 'guards/active_shop.dart';
import 'pages/checkout.dart';
import 'pages/retail.dart';
import 'pages/sales.dart';
import 'pages/wholesale.dart';
import 'states/cart.dart';
import 'states/sales.dart';

class SalesModule extends Module {
  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          '/',
          guards: [ActiveShopGuard()],
          child: (_, __) => const SalesPage(),
        ),
        ChildRoute(
          '/whole',
          guards: [ActiveShopGuard()],
          child: (context, args) => const WholesalePage(),
        ),
        ChildRoute(
          '/retail',
          guards: [ActiveShopGuard()],
          child: (context, args) => const RetailPage(),
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
