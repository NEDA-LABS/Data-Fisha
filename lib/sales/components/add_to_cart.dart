import 'package:flutter/material.dart';

import '../../core/components/text_input.dart';
import '../../core/services/util.dart';
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
            child: Container(
                decoration: _addToCartBoxDecoration(),
                height: 230,
                child: Column(children: <Widget>[
                  _productAndPrice(cart.product, wholesale),
                  _cartQuantityInput(context, cart),
                  _addToCartButton(context, cart, onAddToCart)
                ]))));

_cartQuantityInput(context, CartModel cart) => Container(
    constraints: const BoxConstraints(maxWidth: 200),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: textInput(
        initialText: '${cart.quantity}',
        lines: 1,
        placeholder: 'Quantity',
        onText: (v) {
          // TODO:
        }));

_addToCartButton(context, cart, onAddToCart) => Container(
    margin: const EdgeInsets.all(15),
    height: 40,
    width: MediaQuery.of(context).size.width,
    child: TextButton(
        onPressed: () => onAddToCart(cart),
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
