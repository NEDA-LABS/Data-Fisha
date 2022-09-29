import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/customer.dart';
import 'package:smartstock/sales/services/invoice.dart';

invoiceSalePage(context)=> SaleLikePage(
  wholesale: false,
  title: 'Invoice sale',
  backLink: '/sales/invoice',
  onSubmitCart: onSubmitInvoice,
  customerLikeLabel: 'Select customer',
  onGetPrice: _getPrice,
  onAddToCartView: _onPrepareSalesAddToCartView(context),
  onCustomerLikeList: getCustomerFromCacheOrRemote,
  onCustomerLikeAddWidget: ()=>const CreateCustomerContent(),
  checkoutCompleteMessage: 'Checkout complete.',
);

_onPrepareSalesAddToCartView(context) => (product, onAddToCart) {
  addSaleToCartView(
      onGetPrice: _getPrice,
      cart: CartModel(product: product, quantity: 1),
      onAddToCart: onAddToCart,
      context: context);
};

dynamic _getPrice(product) => doubleOrZero(product['retailPrice']);