import 'package:flutter/material.dart';
import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/customer.dart';
import 'package:smartstock/sales/services/products.dart';
import 'package:smartstock/sales/services/sales.dart';

class SalesCashWhole extends PageBase {
  final TextEditingController searchTextController = TextEditingController();
  final OnBackPage onBackPage;

  SalesCashWhole({super.key, required this.onBackPage})
      : super(pageName: 'SalesCashWhole');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesCashWhole> {
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: true,
      title: 'Wholesale',
      searchTextController: widget.searchTextController,
      backLink: '/sales/cash',
      onSubmitCart: onSubmitWholeSale,
      customerLikeLabel: 'Select customer',
      onBack: widget.onBackPage,
      onGetPrice: _getPrice,
      onAddToCartView: _onPrepareSalesAddToCartView(context),
      onCustomerLikeList: getCustomerFromCacheOrRemote,
      onCustomerLikeAddWidget: () => const CreateCustomerContent(),
      checkoutCompleteMessage: 'Checkout completed.',
      onGetProductsLike: getProductsFromCacheOrRemote,
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
