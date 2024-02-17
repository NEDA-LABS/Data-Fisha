import 'package:flutter/material.dart';
import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/products.dart';

class SalesCashRetail extends PageBase {
  final OnBackPage onBackPage;
  final TextEditingController searchTextController = TextEditingController();

  SalesCashRetail({super.key, required this.onBackPage})
      : super(pageName: 'SalesCashRetail');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesCashRetail> {
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      onQuickItem: (onAddToCartSubmitCallback) {},
      searchTextController: widget.searchTextController,
      title: 'Retail',
      // onSubmitCart: onSubmitRetailSale,
      onBack: widget.onBackPage,
      // customerLikeLabel: 'Select customer',
      onGetPrice: _getPrice,
      onAddToCart: _onPrepareSalesAddToCartView(context),
      // onCustomerLikeList: getCustomerFromCacheOrRemote,
      // onCustomerLikeAddWidget: () => const CreateCustomerContent(),
      // checkoutCompleteMessage: 'Checkout completed.',
      onGetProductsLike: getProductsFromCacheOrRemote,
      onCheckout: (List<CartModel> carts) {},
    );
  }

  _onPrepareSalesAddToCartView(context) {
    return (product, onAddToCart) {
      return salesAddToCart(
        onGetPrice: _getPrice,
        cart: CartModel(product: product, quantity: 1),
        onAddToCart: onAddToCart,
        context: context,
      );
    };
  }

  dynamic _getPrice(product) => doubleOrZero(product['retailPrice']);
}
