import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';

void addPurchaseToCartView({
  required BuildContext context,
  required CartModel cart,
  required onAddToCart,
  required onGetPrice,
}) =>
    showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          child: _AddPurchase2CartDialog(
            onGetPrice: onGetPrice,
            cart: cart,
            onAddToCart: onAddToCart,
          ),
        );
      },
    );

class _AddPurchase2CartDialog extends StatefulWidget {
  final CartModel cart;
  final onAddToCart;
  final onGetPrice;

  const _AddPurchase2CartDialog({
    required this.cart,
    required this.onAddToCart,
    required this.onGetPrice,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_AddPurchase2CartDialog> {
  Map states = {};

  _prepareUpdateState() => ifDoElse(
      (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);

  @override
  void initState() {
    states = {
      "p": widget.cart.product,
      "q": widget.cart.quantity,
      'purchase': _getFromCartProduct(widget.cart, 'purchase'),
      'retailPrice': _getFromCartProduct(widget.cart, 'retailPrice'),
      'wholesalePrice': _getFromCartProduct(widget.cart, 'wholesalePrice'),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _addToCartBoxDecoration(),
      // height: 230,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        shrinkWrap: true,
        children: <Widget>[
          _productAndPrice(states['p'], widget.onGetPrice),
          TextInput(
              label: 'Quantity',
              initialText: '${states['q'] ?? 1}',
              lines: 1,
              type: TextInputType.number,
              onText: (v) => _prepareUpdateState()({'q': doubleOrZero(v)})),
          TextInput(
              label: 'Purchase price',
              initialText: '${states['purchase'] ?? ''}',
              lines: 1,
              type: TextInputType.number,
              onText: (v) =>
                  _prepareUpdateState()({'purchase': doubleOrZero(v)})),
          TextInput(
              label: 'New retail price',
              initialText: '${states['retailPrice'] ?? ''}',
              lines: 1,
              type: TextInputType.number,
              onText: (v) =>
                  _prepareUpdateState()({'retailPrice': doubleOrZero(v)})),
          TextInput(
              label: 'New wholesale price',
              initialText: '${states['wholesalePrice'] ?? ''}',
              lines: 1,
              type: TextInputType.number,
              onText: (v) =>
                  _prepareUpdateState()({'wholesalePrice': doubleOrZero(v)})),
          _addToCartButton(context, states, widget.onAddToCart)
        ],
      ),
    );
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
          onPressed: () => onAddToCart(_getPurchaseCart(states)),
          style: _addToCartButtonStyle(context),
          child: const Text(
            "ADD TO CART",
            // style: TextStyle(color: Colors.white),
          )));

  _getPurchaseCart(states) {
    Map product = states['p'] is Map
        ? (states['p'] as Map<String, dynamic>?)!
        : {"purchase": 0};
    product["purchase"] = states['purchase'];
    product["retailPrice"] = states['retailPrice'];
    product["wholesalePrice"] = states['wholesalePrice'];
    return CartModel(
        product: product as Map<String, dynamic>?, quantity: states['q']);
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
                // color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        _amountWidget(product, onGetPrice)
      ]));

  _amountWidget(product, onGetPrice) => Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text('TZS ${onGetPrice(product)}',
          //formattedAmount(product, wholesale),
          style: const TextStyle(
              // color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17)));

  _addToCartBoxDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      );
}
