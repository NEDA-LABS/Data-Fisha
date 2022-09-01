import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';

import '../../core/components/text_input.dart';
import '../models/cart.model.dart';
import 'cart.dart';

void addToCartView({
  @required BuildContext context,
  bool wholesale = false,
  @required CartModel cart,
  @required onAddToCart,
}) =>
    showDialog(
      context: context,
      builder: (c) => Dialog(
        child: ActiveComponent(
          initialState: {"p": cart.product, "q": cart.quantity},
          builder: (context, states, updateState) => Container(
            decoration: _addToCartBoxDecoration(),
            height: 230,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: <Widget>[
                _productAndPrice(states['p'], wholesale),
                _cartQuantityInput(context, states, updateState),
                _addToCartButton(context, states, onAddToCart)
              ],
            ),
          ),
        ),
      ),
    );

_cartQuantityInput(context, states, updateState) => Container(
    constraints: const BoxConstraints(maxWidth: 200),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: TextInput(
        initialText: '${states['q']}',
        lines: 1,
        placeholder: 'Quantity',
        type: TextInputType.number,
        onText: (v) => updateState({'q': int.tryParse(v)??1})));

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

_productAndPrice(Map<String, dynamic> product, wholesale) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
    child: Column(children: <Widget>[
      Text(product["product"],
          softWrap: true,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
      _amountWidget(product, wholesale)
    ]));

_amountWidget(product, wholesale) => Container(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: Text(formattedAmount(product, wholesale),
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)));

_addToCartBoxDecoration() => const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );
