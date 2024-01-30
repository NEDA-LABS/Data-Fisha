import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';

void addTransferToCartView({
  required BuildContext context,
  required CartModel cart,
  required onAddToCart,
  required onGetPrice,
}) {
  showDialog(
      context: context,
      builder: (c) {
        return Dialog(
            child: _Dialog(
          onAddToCart: onAddToCart,
          cart: cart,
          onGetPrice: onGetPrice,
        ));
      });
}

class _Dialog extends StatefulWidget {
  final CartModel cart;
  final dynamic onAddToCart;
  final dynamic onGetPrice;

  const _Dialog(
      {required this.cart,
      required this.onAddToCart,
      required this.onGetPrice});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Dialog> {
  Map states = {};
  dynamic _updateState;

  @override
  void initState() {
    states = {
      "p": widget.cart.product,
      "q": widget.cart.quantity,
      'purchase': _getFromCartProduct(widget.cart, 'purchase'),
      'retailPrice': _getFromCartProduct(widget.cart, 'retailPrice'),
      'wholesalePrice': _getFromCartProduct(widget.cart, 'wholesalePrice'),
    };
    _updateState = ifDoElse(
        (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _addToCartBoxDecoration(),
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(shrinkWrap: true, children: <Widget>[
          _productAndPrice(states['p'], widget.onGetPrice),
          TextInput(
              label: 'Quantity',
              initialText: '${states['q'] ?? 1}',
              lines: 1,
              type: TextInputType.number,
              onText: (v) => _updateState({'q': doubleOrZero(v)})),
          _addToCartButton(context, states, widget.onAddToCart)
        ]));
  }

  _getFromCartProduct(CartModel cart, String property) {
    var safePrice = compose([
      propertyOr(property, (p0) => 0),
      propertyOr('product', (p0) => {}),
      (x) => cart.toJSON()
    ]);
    return safePrice(cart);
  }

  _addToCartButton(context, states, onAddToCart) => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          onPressed: () => onAddToCart(_getTransferCart(states)),
          style: _addToCartButtonStyle(context),
          child: const Text("ADD TO CART",
              style: TextStyle(color: Colors.white))));

  _getTransferCart(states) {
    Map product = states['p'] is Map
        ? (states['p'] as Map<String, dynamic>?)!
        : {"purchase": 0};
    product["purchase"] = states['purchase'];
    product["retailPrice"] = states['retailPrice'];
    product["wholesalePrice"] = states['wholesalePrice'];
    return CartModel(
        product: product, quantity: doubleOrZero(states['q']));
  }

  _addToCartButtonStyle(context) => ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Theme.of(context).primaryColorDark));

  _productAndPrice(Map<String, dynamic> product, onGetPrice) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
      child: Column(children: <Widget>[
        Text(product["product"],
            softWrap: true,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        _amountWidget(product, onGetPrice)
      ]));

  _amountWidget(product, onGetPrice) => Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text('TZS ${onGetPrice(product)}',
          //formattedAmount(product, wholesale),
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)));

  _addToCartBoxDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      );
}
