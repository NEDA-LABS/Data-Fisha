import 'package:flutter/widgets.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/add_purchase_to_cart.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/purchase.dart';
import 'package:smartstock/stocks/services/supplier.dart';

purchaseCreatePage(BuildContext context) => SaleLikePage(
  wholesale: false,
  title: 'Create purchase',
  backLink: '/stock/purchases',
  customerLikeLabel: 'Choose supplier',
  onSubmitCart: prepareOnSubmitPurchase(context),
  onGetPrice: (product) {
    return doubleOrZero('${product['purchase']}');
  },
  onAddToCartView: _onPrepareSalesAddToCartView(context, false),
  onCustomerLikeList: getSupplierFromCacheOrRemote,
  onCustomerLikeAddWidget: createSupplierContent,
  checkoutCompleteMessage: 'Purchase complete.',
  onGetProductsLike: getStockFromCacheOrRemote,
);

_onPrepareSalesAddToCartView(context, wholesale) => (product, onAddToCart) {
  addPurchaseToCartView(
      onGetPrice: (product) {
        return doubleOrZero('${product['purchase']}');
      },
      cart: CartModel(product: product, quantity: 1),
      onAddToCart: onAddToCart,
      context: context);
};