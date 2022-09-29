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
      return Dialog(
        child: _Dialog(
          cart: cart,
          onAddToCart: onAddToCart,
          onGetPrice: onGetPrice,
        ),
      );
    },
  );
}

class _Dialog extends StatefulWidget {
  final CartModel cart;
  final onAddToCart;
  final onGetPrice;

  const _Dialog({
    required this.cart,
    required this.onAddToCart,
    required this.onGetPrice,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Dialog> {
  Map states = {};
  var updateState;

  @override
  void initState() {
    states = {'p': widget.cart.product, 'q': widget.cart.quantity};
    updateState = ifDoElse(
        (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _addToCartBoxDecoration(),
      height: 230,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: <Widget>[
          _productAndPrice(states['p'], widget.onGetPrice),
          _cartQuantityInput(context, states, updateState),
          _addToCartButton(context, states, widget.onAddToCart)
        ],
      ),
    );
  }
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
