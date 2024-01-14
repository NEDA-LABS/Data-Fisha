import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/components/cart_preview.dart';
import 'package:smartstock/core/components/list_of_products_like.dart';

typedef OnAddToCart = Function(dynamic);
typedef OnAddToCartView = Function(dynamic product, OnAddToCart onAddToCart);
typedef OnGetPrice = dynamic Function(dynamic);

class SalesLikeBody extends StatelessWidget {
  final List products;
  final List carts;
  final bool wholesale;
  final OnAddToCart onAddToCart;
  final Function() onShowCheckout;
  final OnAddToCartView onAddToCartView;
  final OnGetPrice onGetPrice;

  const SalesLikeBody({
    required this.products,
    this.carts = const [],
    this.wholesale = false,
    required this.onAddToCart,
    required this.onShowCheckout,
    required this.onAddToCartView,
    required this.onGetPrice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: ListOfProductsLike(
          onAddToCart: onAddToCart,
          products: products,
          onAddToCartView: onAddToCartView,
          onGetPrice: onGetPrice,
        ),
      ),
      hasEnoughWidth(context)
          ? const Positioned(left: 0, child: SizedBox(height: 0))
          : Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: cartPreview(carts, wholesale, context, onShowCheckout))
    ]);
  }
}
