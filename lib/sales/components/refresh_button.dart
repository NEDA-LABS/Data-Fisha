import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';
import 'package:smartstock_pos/util.dart';

Widget get salesRefreshButton => selectorComponent<SalesState, bool>(
      selector: (state) => state.loadProductsProgress,
      builder: (context, value) =>
          !value ? _addToCartOrRefreshIcon() : SizedBox(width: 0,height: 0,),
    );

Widget _addToCartOrRefreshIcon() => selectorComponent<CartState, CartModel>(
      selector: (state) => state.currentCartModel,
      builder: (context, value) => value != null
          ? FloatingActionButton(
              child: Icon(Icons.close),
              onPressed: () {
                getState<CartState>().setCurrentCartToBeAdded(null);
                Navigator.pop(context);
              },
            )
          : _refreshStocks(),
    );

Widget _refreshStocks() => selectorComponent<CartState, List>(
      selector: (state) => state.cartProductsArray,
      builder: (context, value) => value.length <= 0
          ? FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () => getState<SalesState>().getStockFromRemote(),
            )
          : SizedBox(height: 0,width: 0,),
    );
