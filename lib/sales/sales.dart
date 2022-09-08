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
    child: (context, args) => SaleLikePage(
      wholesale: true,
      title: 'Wholesale',
      backLink: '/sales/',
      onSubmitCart: onSubmitWholeSale,
      onGetPrice: (product) {
        return _getPrice(product, true);
      },
    ),
  );
  final retail = ChildRoute(
    '/retail',
    guards: [ActiveShopGuard()],
    child: (context, args) => SaleLikePage(
      wholesale: false,
      title: 'Retail',
      backLink: '/sales/',
      onSubmitCart: onSubmitRetailSale,
      onGetPrice: (product) {
        return _getPrice(product, false);
      },
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
    child: (context, args) => SaleLikePage(
      wholesale: false,
      title: 'Invoice sale',
      backLink: '/sales/invoice',
      onSubmitCart: onSubmitInvoice,
      onGetPrice: (product) {
        return _getPrice(product, false);
      },
    ),
  );

  @override
  List<ChildRoute> get routes =>
      [home, wholeSale, retail, customer, invoice, credit];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => SalesState())];
}

int _getPrice(product, wholesale) =>
    product[wholesale ? "wholesalePrice" : 'retailPrice'] is double
        ? product[wholesale ? "wholesalePrice" : 'retailPrice'].toInt()
        : product[wholesale ? "wholesalePrice" : 'retailPrice'];
