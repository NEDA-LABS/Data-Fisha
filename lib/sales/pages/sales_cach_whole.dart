import 'package:flutter/material.dart';
import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/customer.dart';
import 'package:smartstock/sales/services/sales.dart';

class SalesCashWhole extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;
  final TextEditingController searchTextController = TextEditingController();
  SalesCashWhole({Key? key, required this.onGetModulesMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: true,
      title: 'Wholesale',
      searchTextController: searchTextController,
      backLink: '/sales/cash',
      onSubmitCart: onSubmitWholeSale,
      customerLikeLabel: 'Select customer',
      onGetPrice: _getPrice,
      onAddToCartView: _onPrepareSalesAddToCartView(context),
      onCustomerLikeList: getCustomerFromCacheOrRemote,
      onCustomerLikeAddWidget: () => const CreateCustomerContent(),
      checkoutCompleteMessage: 'Checkout complete.',
      onGetProductsLike: getStockFromCacheOrRemote,
      onGetModulesMenu: onGetModulesMenu,
    );
  }

  dynamic _getPrice(product) => doubleOrZero(product["wholesalePrice"]);

  _onPrepareSalesAddToCartView(context) {
    return (product, onAddToCart) {
      salesAddToCart(
          onGetPrice: _getPrice,
          cart: CartModel(product: product, quantity: 1),
          onAddToCart: onAddToCart,
          context: context);
    };
  }
}
