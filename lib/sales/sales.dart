import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/invoices.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/sales/services/customer.dart';
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
      customerLikeLabel: 'Select customer',
      onGetPrice: (product) {
        return _getPrice(product, true);
      },
      onAddToCartView: _onPrepareSalesAddToCartView(context, true),
      onCustomerLikeList: getCustomerFromCacheOrRemote,
      onCustomerLikeAddWidget: createCustomerContent,
      checkoutCompleteMessage: 'Checkout complete.',
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
      customerLikeLabel: 'Select customer',
      onGetPrice: (product) {
        return _getPrice(product, false);
      },
      onAddToCartView: _onPrepareSalesAddToCartView(context, false),
      onCustomerLikeList: getCustomerFromCacheOrRemote,
      onCustomerLikeAddWidget: createCustomerContent,
      checkoutCompleteMessage: 'Checkout complete.',
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
      customerLikeLabel: 'Select customer',
      onGetPrice: (product) {
        return _getPrice(product, false);
      },
      onAddToCartView: _onPrepareSalesAddToCartView(context, true),
      onCustomerLikeList: getCustomerFromCacheOrRemote,
      onCustomerLikeAddWidget: createCustomerContent,
      checkoutCompleteMessage: 'Checkout complete.',
    ),
  );

  @override
  List<ChildRoute> get routes =>
      [home, wholeSale, retail, customer, invoice, credit];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => SalesState())];
}

_onPrepareSalesAddToCartView(context, wholesale) => (product, onAddToCart) {
      addSaleToCartView(
          onGetPrice: (product) {
            return _getPrice(product, wholesale);
          },
          cart: CartModel(product: product, quantity: 1),
          onAddToCart: onAddToCart,
          context: context);
    };

dynamic _getPrice(product, wholesale) =>
    doubleOrZero(product[wholesale ? "wholesalePrice" : 'retailPrice']);
