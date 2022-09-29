import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';

void addSaleToCartView({
  required BuildContext context,
  required CartModel cart,
  required onAddToCart,
  required onGetPrice,
}) {
  showDialog(
    context: context,
    builder: (c) {
      Map states = {'p': cart.product, 'q': cart.quantity};
      return Dialog(
        child: StatefulBuilder(
          builder: (context, setState) {
            // updateState(map) {
            //   map is Map
            //       ? setState(() {
            //           states.addAll(map);
            //         })
            //       : null;
            // }
            var updateState = ifDoElse((x) => x is Map, (x) =>
                setState(() => states.addAll(x)), (x) => null);
            return Container(
              decoration: _addToCartBoxDecoration(),
              height: 230,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: <Widget>[
                  _productAndPrice(states['p'], onGetPrice),
                  _cartQuantityInput(context, states, updateState),
                  _addToCartButton(context, states, onAddToCart)
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

_cartQuantityInput(context, states, updateState) => Container(
    constraints: const BoxConstraints(maxWidth: 200),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: TextInput(
        initialText: '${states['q']}',
        lines: 1,
        placeholder: 'Quantity',
        type: TextInputType.number,
        onText: (v) => updateState({'q': doubleOr(v, 1)})));

_addToCartButton(context, states, onAddToCart) => Container(
    margin: const EdgeInsets.all(15),
    height: 40,
    width: MediaQuery.of(context).size.width,
    child: TextButton(
        onPressed: () =>
            onAddToCart(CartModel(product: states['p'], quantity: states['q'])),
        style: _addToCartButtonStyle(context),
        child:
            const Text("ADD TO CART", style: TextStyle(color: Colors.white))));

_addToCartButtonStyle(context) => ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(Theme.of(context).primaryColorDark));

_productAndPrice(Map<String, dynamic> product, onGetPrice) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
    child: Column(children: <Widget>[
      Text(product["product"],
          softWrap: true,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
      _amountWidget(product, onGetPrice)
    ]));

_amountWidget(product, onGetPrice) => Container(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: Text(
        'TZS ${onGetPrice(product)}', //formattedAmount(product, wholesale),
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)));

_addToCartBoxDecoration() => const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );
