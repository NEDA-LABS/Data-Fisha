import 'package:flutter/material.dart';

import '../../common/services/util.dart';
import '../states/cart.state.dart';
import 'cart.component.dart';
import 'list_of_products.dart';

Widget saleBody({bool wholesale = false}) => Stack(
      children: [
        Positioned(
          child: listOfProducts(wholesale: wholesale),
          bottom: 0,
          right: 0,
          left: 0,
          top: 0,
        ),
        Positioned(
          child: consumerComponent<CartState>(
            builder: (context, cartState) =>
                cartState.cartProductsArray.length > 0
                    ? CartComponents().cartPreview(wholesale: wholesale)
                    : Container(
                        height: 0,
                        width: 0,
                      ),
          ),
          bottom: 16,
          left: 16,
          right: 16,
        )
      ],
    );
