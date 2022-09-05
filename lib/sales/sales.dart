import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/invoices.dart';

import 'guards/active_shop.dart';
import 'pages/index.dart';
import 'pages/sale.dart';
import 'states/sales.dart';

class SalesModule extends Module {
  @override
  List<ChildRoute> get routes => [
        ChildRoute('/',
            guards: [ActiveShopGuard()], child: (_, __) => const SalesPage()),
        ChildRoute('/whole',
            guards: [ActiveShopGuard()],
            child: (context, args) =>
                SalePage(wholesale: true, title: 'Wholesale')),
        ChildRoute('/retail',
            guards: [ActiveShopGuard()],
            child: (context, args) =>
                SalePage(wholesale: false, title: 'Retail')),
        ChildRoute('/customers',
            guards: [ActiveShopGuard()],
            child: (context, args) => CustomersPage(args)),
        ChildRoute('/invoice',
            guards: [ActiveShopGuard()],
            child: (context, args) => InvoicesPage(args)),
        ChildRoute('/credit',
            guards: [ActiveShopGuard()],
            child: (context, args) =>
                SalePage(wholesale: false, title: 'Invoice sale'))
      ];

  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => SalesState()),
        // Bind.lazySingleton((i) => CartState())
      ];
}
