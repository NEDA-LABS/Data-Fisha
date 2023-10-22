import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';

Widget cartPreview(List carts, wholesale, context, onShowCheckout) =>
    carts.isNotEmpty
        ? _cartPreview(carts, wholesale, context, onShowCheckout)
        : const SizedBox(width: 0, height: 0);

Widget _cartPreview(List carts, bool wholesale, context, onShowCheckout) =>
    TextButton(
        onPressed: onShowCheckout,
        child: Builder(
            builder: (context) => Container(
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: BodyLarge(text: '${_getTotalItems(carts)} Items',
                    textAlign: TextAlign.center,
                    color: Theme.of(context).colorScheme.onPrimary,
                    overflow: TextOverflow.ellipsis))));

_getTotalItems(List<dynamic> carts) =>
    carts.fold(0, (dynamic a, element) => a + element.quantity);

// _format({bool wholesale}) => NumberFormat.currency(name: 'TZS ')
//     .format(getState<CartState>().getFinalTotal(isWholesale: wholesale));
