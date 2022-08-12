import 'package:flutter/material.dart';

import '../../common/util.dart';
import '../states/cart.state.dart';
import '../states/sales.state.dart';

Widget get salesRefreshButton {
  return consumerComponent<SalesState>(
    builder: (context, salesState) => !salesState.loadProductsProgress
        ? consumerComponent<CartState>(builder: (context, cartState) {
            return cartState.currentCartModel != null
                ? FloatingActionButton(
                    child: Icon(Icons.close),
                    onPressed: () {
                      getState<CartState>().setCurrentCartToBeAdded(null);
                      Navigator.pop(context);
                    },
                  )
                : cartState.cartProductsArray.length <= 0
                    ? FloatingActionButton(
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          salesState.getStockFromRemote();
                        },
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      );
          })
        : Container(),
  );
}
