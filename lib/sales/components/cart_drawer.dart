import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/util.dart';
import '../models/cart.model.dart';
import '../states/cart.dart';
import 'cart.dart';

Widget cartDrawer({@required List<CartModel> carts, bool wholesale = false}) =>
    Column(children: [
      Expanded(
          child: ListView.builder(
              itemCount: carts.length,
              itemBuilder: _cartListItemBuilder(carts, wholesale))),
      _cartSummary(wholesale: wholesale)
    ]);

Widget _cartSummary({
  @required BuildContext context,
  @required List<CartModel> carts,
  bool wholesale = false,
  bool isSubmitting = false,
  int discount = 0,
  Function(dynamic) onDiscount,
}) =>
    Card(
      elevation: 5,
      child: Column(
        children: [
          _totalAmountRow(carts),
          _discountRow(discount, onDiscount),
          Container(
            margin: const EdgeInsets.all(8),
            height: 54,
            color: Theme.of(context).primaryColorDark,
            child: isSubmitting
                ? _progressIndicator()
                : _submitButton(carts, discount),
          )
        ],
      ),
    );

_submitButton(List<CartModel> carts, int discount) => TextButton(
    onPressed: _submit,
    child: Row(children: [
      const Expanded(
          child: Text('Checkout',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
      Text(
          NumberFormat.currency(name: 'TZS ')
              .format(_getFinalTotal(carts, discount)),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          softWrap: true)
    ]));

_getFinalTotal(List<CartModel> carts, int discount) => '';

_progressIndicator() => const Center(
    child: CircularProgressIndicator(backgroundColor: Colors.white));

_totalAmountRow(List<CartModel> carts) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(
              child: Text("Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Text(_getTotalAmount(carts),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );

String _getTotalAmount(List<CartModel> carts) => '';

_discountRow(int discount, Function(dynamic) onDiscount) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(flex: 1, child: Text('Discount ( TZS )')),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), border: Border.all()),
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            height: 38,
            width: 150,
            child: TextField(
                autofocus: false,
                maxLines: 1,
                minLines: 1,
                keyboardType: TextInputType.number,
                onChanged: onDiscount,
                decoration: const InputDecoration(
                    hintText: "Discount", border: InputBorder.none)),
          ),
        ],
      ),
    );

Widget _checkoutCartItem({
  @required CartModel cart,
  bool wholesale = false,
  @required BuildContext context,
}) =>
    Column(
      children: [
        ListTile(
          title: Text(cart.product['product']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wholesale
                  ? Text(
                      '${cart.quantity} (x${cart.product['wholesaleQuantity']}) ${cart.product['unit']}')
                  : Text('${cart.quantity} ${cart.product['unit']} '
                      '@ ${formattedAmount(cart.product, wholesale)}'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => getState<CartState>()
                        .decrementQtyOfProductInCart(cart.product['id']),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => getState<CartState>()
                        .incrementQtyOfProductInCart(cart.product['id']),
                  ),
                ],
              )
            ],
          ),
          isThreeLine: false,
          trailing: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () => getState<CartState>().removeCart(cart, wholesale),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Divider(color: Colors.grey))
      ],
    );

_cartListItemBuilder(carts, wholesale) => (context, index) => _checkoutCartItem(
    cart: carts[index], wholesale: wholesale, context: context);

void _submit() {
  // TODO: cartState
  //     .checkout(wholesale: wholesale)
  //     .catchError((e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content:
  //       Text("Fail to checkout, please retry"),
  //     ),
  //   );
  // });
}
