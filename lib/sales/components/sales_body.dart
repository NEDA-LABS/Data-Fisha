import 'package:flutter/material.dart';

import 'cart_preview.dart';
import 'list_of_products.dart';

Widget salesBody({
  @required List products,
  bool wholesale = false,
  @required onAddToCart,
}) =>
    Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: listOfProducts(
              wholesale: wholesale,
              products: products,
              onAddToCart: onAddToCart),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: cartPreview(wholesale: wholesale),
        )
      ],
    );
