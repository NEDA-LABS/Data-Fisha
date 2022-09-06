import 'package:flutter/material.dart';
import 'package:smartstock/core/services/util.dart';

import 'cart_preview.dart';
import 'list_of_products.dart';

Widget salesBody(
        {@required List products,
        @required List carts,
        bool wholesale = false,
        @required onAddToCart,
        @required onShowCheckout,
        @required BuildContext context}) =>
    Stack(children: [
      Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: listOfProducts(
            wholesale: wholesale,
            products: products,
            onAddToCart: onAddToCart,
          )),
      hasEnoughWidth(context)
          ? const Positioned(left: 0, child: SizedBox(height: 0))
          : Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: cartPreview(carts, wholesale, context, onShowCheckout))
    ]);
