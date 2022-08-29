import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock_pos/sales/components/cart_drawer.dart';

import '../../core/services/util.dart';
import '../states/cart.dart';

Widget cartPreview(List carts, wholesale, context) => carts.isNotEmpty
    ? _cartPreview(carts, wholesale, context)
    : const SizedBox(width: 0, height: 0);

Widget _cartPreview(List carts, bool wholesale, context) => TextButton(
      onPressed: () => showBottomSheet(
        enableDrag: true,
          context: context,
          builder: (context) => cartDrawer(carts: carts, wholesale: wholesale, context: context)),
      child: Builder(builder: (context) {
        return Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Text(
            '${_getTotalItems(carts)} Items',
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      }),
    );

_getTotalItems(List<dynamic> carts) =>
    carts.fold(0, (a, element) => a + element.quantity);

// _format({bool wholesale}) => NumberFormat.currency(name: 'TZS ')
//     .format(getState<CartState>().getFinalTotal(isWholesale: wholesale));
