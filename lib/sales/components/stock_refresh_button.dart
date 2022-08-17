import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../states/cart.dart';
import '../states/sales.dart';

Widget get salesRefreshButton {
  return consumerComponent<SalesState>(
    builder: (context, salesState) => !salesState.loadProductsProgress
        ? consumerComponent<CartState>(builder: (context, cartState) {
            return cartState.currentCartModel != null
                ? FloatingActionButton(
                    child: const Icon(Icons.close),
                    onPressed: () {
                      getState<CartState>().setCurrentCartToBeAdded(null);
                      Navigator.pop(context);
                    },
                  )
                : cartState.cartProductsArray.isEmpty
                    ? FloatingActionButton(
                        child: const Icon(Icons.refresh),
                        onPressed: () {
                          salesState.getStockFromRemote();
                        },
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      );
          })
        : Container(),
  );
}
