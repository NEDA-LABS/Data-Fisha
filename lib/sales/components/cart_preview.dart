import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/util.dart';
import '../states/cart.dart';

Widget cartPreview({bool wholesale}) => consumerComponent<CartState>(
      // selector: (state) => state.cartProductsArray,
      builder: (context, state) =>
          state.cartProductsArray.isNotEmpty ? _cartPreview(wholesale: wholesale) : const SizedBox(width: 0,height: 0,),
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
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Text(
            // '${state.calculateCartItems()}',
            ' Items = ${_format(wholesale: wholesale)}',
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      }),
    );

_format({bool wholesale}) => NumberFormat.currency(name: 'TZS ')
    .format(getState<CartState>().getFinalTotal(isWholesale: wholesale));
