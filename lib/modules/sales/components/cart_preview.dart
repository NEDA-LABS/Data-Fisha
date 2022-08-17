import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/util.dart';

Widget cartPreview({bool wholesale}) => consumerComponent<CartState>(
      // selector: (state) => state.cartProductsArray,
      builder: (context, state) =>
          state.cartProductsArray.length > 0 ? _cartPreview(wholesale: wholesale) : SizedBox(width: 0,height: 0,),
    );

Widget _cartPreview({bool wholesale = false}) => TextButton(
      onPressed: () =>
          navigateTo('/sales/checkout/${wholesale ? 'whole' : 'retail'}'),
      child: Builder(builder: (context) {
        return Container(
          height: 54,
          alignment: Alignment.center,
//        width: 300,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(
            // '${state.calculateCartItems()}',
            ' Items = ${_format(wholesale: wholesale)}',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      }),
    );

_format({bool wholesale}) => NumberFormat.currency(name: 'TZS ')
    .format(getState<CartState>().getFinalTotal(isWholesale: wholesale));
