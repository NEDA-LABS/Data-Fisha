import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';

void addExpenseToCartView({
  required BuildContext context,
  required CartModel cart,
  required onAddToCart,
  required onGetPrice,
}) =>
    showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          child: _AddExpense2CartDialog(
            onGetPrice: onGetPrice,
            cart: cart,
            onAddToCart: onAddToCart,
          ),
        );
      },
    );

class _AddExpense2CartDialog extends StatefulWidget {
  final CartModel cart;
  final dynamic onAddToCart;
  final dynamic onGetPrice;

  const _AddExpense2CartDialog({
    required this.cart,
    required this.onAddToCart,
    required this.onGetPrice,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_AddExpense2CartDialog> {
  Map states = {};

  _prepareUpdateState() => ifDoElse(
      (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);

  @override
  void initState() {
    states = {"p": widget.cart.product, "amount": 0};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _addToCartBoxDecoration(),
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        shrinkWrap: true,
        children: <Widget>[
          _item(states['p']),
          TextInput(
              label: 'Amount',
              initialText: '${states['amount'] ?? 0}',
              lines: 1,
              type: TextInputType.number,
              onText: (v) =>
                  _prepareUpdateState()({'amount': doubleOrZero(v)})),
          _addToCartButton(context, states, widget.onAddToCart)
        ],
      ),
    );
  }

  _addToCartButton(context, states, onAddToCart) => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          onPressed: () => onAddToCart(_getPurchaseCart(states)),
          style: _addToCartButtonStyle(context),
          child: const Text("ADD TO CART",
              style: TextStyle(color: Colors.white))));

  _getPurchaseCart(states) {
    Map product =
        states['p'] is Map ? (states['p'] as Map<String, dynamic>?)! : {};
    product['amount'] = states['amount'];
    return CartModel(
        product: product as Map<String, dynamic>?, quantity: 1);
  }

  _addToCartButtonStyle(context) => ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Theme.of(context).primaryColorDark));

  _item(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        product["name"],
        softWrap: true,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  _addToCartBoxDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      );
}
