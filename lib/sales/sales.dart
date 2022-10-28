import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/states/sales_external_services.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/sales_cach_whole.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';
import 'package:smartstock/sales/states/sales.dart';

class SalesModule extends Module {
  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          '/',
          guards: [ActiveShopGuard()],
          child: (_, __) => SalesPage(
            services: SalesExternalServiceState().salesExternalServices,
          ),
        ),
        ChildRoute(
          '/cash',
          guards: [ActiveShopGuard()],
          child: (context, args) => const SalesCashPage(),
        ),
        ChildRoute(
          '/cash/whole',
          guards: [ActiveShopGuard()],
          child: (context, args) => SalesCashWhole(),
        ),
        ChildRoute(
          '/cash/retail',
          guards: [ActiveShopGuard()],
          child: (context, args) => SalesCashRetail(),
        ),
        ChildRoute(
          '/customers',
          guards: [ActiveShopGuard()],
          child: (context, args) => CustomersPage(args),
        ),
        ChildRoute(
          '/invoice',
          guards: [ActiveShopGuard()],
          child: (context, args) => InvoicesPage(args),
        ),
        ChildRoute(
          '/invoice/create',
          guards: [ActiveShopGuard()],
          child: (context, args) => invoiceSalePage(context),
        ),
        ..._getExternalServices()
      ];

  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => SalesState()),
        Bind.lazySingleton((i) => SalesExternalServiceState())
      ];

  _getExternalServices() {
    return SalesExternalServiceState()
        .salesExternalServices
        .map<ChildRoute>((e) {
      return ChildRoute(
        e.pageLink,
        guards: [ActiveShopGuard()],
        child: e.onBuild,
      );
    });
  }
}
