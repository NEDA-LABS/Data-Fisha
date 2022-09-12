import 'package:flutter/material.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/cart_preview.dart';
import 'package:smartstock/sales/components/list_of_products.dart';

Widget salesLikeBody(
        {required List products,
        required List? carts,
        required bool wholesale,
        required onAddToCart,
        required onShowCheckout,
        required onAddToCartView,
        required onGetPrice,
        required BuildContext context}) =>
    Stack(children: [
      Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: listOfProducts(
              onAddToCart: onAddToCart,
              products: products,
              onAddToCartView: onAddToCartView,
              onGetPrice: onGetPrice)),
      hasEnoughWidth(context)
          ? const Positioned(left: 0, child: SizedBox(height: 0))
          : Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: cartPreview(carts!, wholesale, context, onShowCheckout))
    ]);
