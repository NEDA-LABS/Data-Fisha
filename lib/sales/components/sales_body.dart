import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/cart_preview.dart';
import 'package:smartstock_pos/modules/sales/components/product_grid_list.dart';

Widget salesBody({bool wholesale = false}) => Stack(
      children: [
        Positioned(
          child: listOfProducts(wholesale: wholesale),
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
        ),
        Positioned(
          child: cartPreview(wholesale: wholesale),
          bottom: 16,
          left: 16,
          right: 16,
        )
      ],
    );
