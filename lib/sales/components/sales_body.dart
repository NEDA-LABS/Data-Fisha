import 'package:flutter/material.dart';

import 'cart_preview.dart';
import 'list_of_products.dart';

Widget salesBody({bool wholesale = false}) => Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: listOfProducts(wholesale: wholesale),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: cartPreview(wholesale: wholesale),
        )
      ],
    );
