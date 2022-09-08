import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/invoices.dart';
import 'package:smartstock/sales/pages/sale.dart';
import 'package:smartstock/sales/services/invoice.dart';
import 'package:smartstock/sales/services/sales.dart';
import 'package:smartstock/sales/states/sales.dart';

class SalesModule extends Module {
  final home = ChildRoute(
    '/',
    guards: [ActiveShopGuard()],
    child: (_, __) => const SalesPage(),
  );
  final wholeSale = ChildRoute(
    '/whole',
    guards: [ActiveShopGuard()],
    child: (context, args) => SalePage(
      wholesale: true,
      title: 'Wholesale',
      onSubmitCart: onSubmitWholeSale,
    ),
  );
  final retail = ChildRoute(
    '/retail',
    guards: [ActiveShopGuard()],
    child: (context, args) => SalePage(
      wholesale: false,
      title: 'Retail',
      onSubmitCart: onSubmitRetailSale,
    ),
  );
  final customer = ChildRoute(
    '/customers',
    guards: [ActiveShopGuard()],
    child: (context, args) => CustomersPage(args),
  );
  final invoice = ChildRoute(
    '/invoice',
    guards: [ActiveShopGuard()],
    child: (context, args) => InvoicesPage(args),
  );
  final credit = ChildRoute(
    '/invoice/create',
    guards: [ActiveShopGuard()],
    child: (context, args) => SalePage(
      wholesale: false,
      title: 'Invoice sale',
      onSubmitCart: onSubmitInvoice,
    ),
  );

  @override
  List<ChildRoute> get routes =>
      [home, wholeSale, retail, customer, invoice, credit];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => SalesState())];
}
