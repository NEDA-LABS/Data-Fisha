import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';

void addPurchaseToCartView({
  @required BuildContext context,
  @required CartModel cart,
  @required onAddToCart,
  @required onGetPrice,
}) =>
    showDialog(
      context: context,
      builder: (c) => Dialog(
        child: ActiveComponent(
          initialState: {
            "p": cart.product,
            "q": cart.quantity,
            'purchase': _getFromCartProduct(cart, 'purchase'),
            'retailPrice': _getFromCartProduct(cart, 'retailPrice'),
            'wholesalePrice': _getFromCartProduct(cart, 'wholesalePrice'),
          },
          builder: (context, states, updateState) => Container(
            decoration: _addToCartBoxDecoration(),
            // height: 230,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              shrinkWrap: true,
              children: <Widget>[
                _productAndPrice(states['p'], onGetPrice),
                TextInput(
                    label: 'Quantity',
                    initialText: '${states['q'] ?? 1}',
                    lines: 1,
                    type: TextInputType.number,
                    onText: (v) =>
                        updateState({'q': int.tryParse(v) ?? 1})),
                TextInput(
                    label: 'Purchase price',
                    initialText: '${states['purchase'] ?? ''}',
                    lines: 1,
                    type: TextInputType.number,
                    onText: (v) =>
                        updateState({'purchase': int.tryParse(v) ?? 1})),
                TextInput(
                    label: 'New retail price',
                    initialText: '${states['retailPrice'] ?? ''}',
                    lines: 1,
                    type: TextInputType.number,
                    onText: (v) =>
                        updateState({'retailPrice': int.tryParse(v) ?? 1})),
                TextInput(
                    label: 'New wholesale price',
                    initialText: '${states['wholesalePrice'] ?? ''}',
                    lines: 1,
                    type: TextInputType.number,
                    onText: (v) => updateState(
                        {'wholesalePrice': int.tryParse(v) ?? 1})),
                _addToCartButton(context, states, onAddToCart)
              ],
            ),
          ),
        ),
      ),
    );

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
        child:
            const Text("ADD TO CART", style: TextStyle(color: Colors.white))));

_getPurchaseCart(states) {
  Map product = states['p'] is Map
      ? states['p'] as Map<String, dynamic>
      : {"purchase": 0};
  product["purchase"] = states['purchase'];
  product["retailPrice"] = states['retailPrice'];
  product["wholesalePrice"] = states['wholesalePrice'];
  return CartModel(product: product, quantity: states['q']);
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
