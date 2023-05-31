import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/customer.dart';
import 'package:smartstock/sales/services/invoice.dart';

class InvoiceSalePage extends StatelessWidget {
  final OnBackPage onBackPage;

  const InvoiceSalePage({Key? key, required this.onBackPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      title: 'Invoice sale',
      backLink: '/sales/invoice',
      onSubmitCart: onSubmitInvoice,
      customerLikeLabel: 'Select customer',
      onBack: onBackPage,
      onGetPrice: _getPrice,
      onAddToCartView: _onPrepareSalesAddToCartView(context),
      onCustomerLikeList: getCustomerFromCacheOrRemote,
      onCustomerLikeAddWidget: () => const CreateCustomerContent(),
      checkoutCompleteMessage: 'Checkout completed.',
      onGetProductsLike: getStockFromCacheOrRemote,
    );
  }

  _onPrepareSalesAddToCartView(context) => (product, onAddToCart) {
        salesAddToCart(
          onGetPrice: _getPrice,
          cart: CartModel(product: product, quantity: 1),
          onAddToCart: onAddToCart,
          context: context,
        );
      };

  dynamic _getPrice(product) => doubleOrZero(product['retailPrice']);
}
