import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/pages/cash_sales.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/invoice_sale.dart';
import 'package:smartstock/sales/pages/invoices.dart';
import 'package:smartstock/sales/pages/retail_sale.dart';
import 'package:smartstock/sales/pages/whole_sale.dart';
import 'package:smartstock/sales/states/sales.dart';

class SalesModule extends Module {
  final home = ChildRoute(
    '/',
    guards: [ActiveShopGuard()],
    child: (_, __) => const SalesPage(),
  );
  final cash = ChildRoute(
    '/cash',
    guards: [ActiveShopGuard()],
    child: (context, args) => const CashSalesPage(),
  );
  final wholeSale = ChildRoute(
    '/cash/whole',
    guards: [ActiveShopGuard()],
    child: (context, args) => wholeSalePage(context),
  );
  final retail = ChildRoute(
    '/cash/retail',
    guards: [ActiveShopGuard()],
    child: (context, args) => retailSalePage(context),
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
    child: (context, args) => invoiceSalePage(context),
  );

  @override
  List<ChildRoute> get routes =>
      [home, cash, wholeSale, retail, customer, invoice, credit];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => SalesState())];
}

// _onPrepareSalesAddToCartView(context, wholesale) => (product, onAddToCart) {
//       addSaleToCartView(
//           onGetPrice: (product) {
//             return _getPrice(product, wholesale);
//           },
//           cart: CartModel(product: product, quantity: 1),
//           onAddToCart: onAddToCart,
//           context: context);
//     };
//
// dynamic _getPrice(product, wholesale) =>
//     doubleOrZero(product[wholesale ? "wholesalePrice" : 'retailPrice']);
