import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/sales/components/cart.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/services/cart.dart';
import 'package:smartstock/sales/services/customer.dart';

Widget cartDrawer(
        {@required List carts,
        @required Function(dynamic) onCheckout,
        @required Function(dynamic) onGetPrice,
        @required Function(String) onRemoveItem,
        @required onCustomerLikeList,
        @required Function(String, int) onAddItem,
        @required bool wholesale,
        String customerLikeLabel = 'Choose customer',
        context,
        @required customer,
        @required onCustomer}) =>
    Scaffold(
      body: Column(children: [
        AppBar(title: const Text('Cart'), elevation: 0),
        ChoicesInput(
            initialText: customer,
            placeholder: customerLikeLabel,
            showBorder: false,
            onText: onCustomer,
            onLoad: onCustomerLikeList,
            getAddWidget: () => createCustomerContent(),
            onField: (x) => x['name'] ?? x['displayName']),
        Expanded(
            child: ListView.builder(
                controller: ScrollController(),
                itemCount: carts.length,
                itemBuilder: _cartListItemBuilder(
                    carts, wholesale, onAddItem, onRemoveItem, onGetPrice))),
        _cartSummary(carts, wholesale, context, onCheckout, onGetPrice)
      ]),
    );

Widget _cartSummary(List carts, wholesale, context, onCheckout, onGetPrice) =>
    ActiveComponent(
      initialState: const {'discount': 0, 'loading': false},
      builder: (context, states, updateState) => Card(
        elevation: 5,
        child: Column(
          children: [
            _totalAmountRow(carts, wholesale, onGetPrice),
            _discountRow(states['discount'],
                (v) => updateState({'discount': int.tryParse(v) ?? 0})),
            Container(
              margin: const EdgeInsets.all(8),
              height: 54,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: states['loading']
                  ? _progressIndicator()
                  : _submitButton(carts, states['discount'], wholesale,
                      onCheckout, updateState, onGetPrice),
            )
          ],
        ),
      ),
    );

_submitButton(List carts, discount, bool wholesale, onCheckout, updateState,
        onGetPrice) =>
    TextButton(
      onPressed: () {
        updateState({'loading': true});
        onCheckout(discount)
            .whenComplete(() => updateState({'loading': false}));
      },
      child: Row(
        children: [
          const Expanded(
              child: Text('Checkout',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          Text(
              _formatPrice(
                  _getFinalTotal(carts, discount, wholesale, onGetPrice)),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              softWrap: true)
        ],
      ),
    );

_formatPrice(price) =>
    NumberFormat.currency(name: 'TZS ').format(int.tryParse('$price') ?? 0);

_getFinalTotal(List carts, int discount, bool wholesale, onGetPrice) => carts
    .fold(-discount, (t, c) => t + getProductPrice(c, wholesale, onGetPrice));

_progressIndicator() => const Center(
    child: CircularProgressIndicator(backgroundColor: Colors.white));

_totalAmountRow(List carts, wholesale, onGetPrice) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(
              child: Text("Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Text('${cartTotalAmount(carts, wholesale, onGetPrice)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );

_discountRow(int discount, Function(dynamic) onDiscount) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(child: Text('Discount ( TZS )')),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), border: Border.all()),
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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

Widget _checkoutCartItem(
        {@required cart,
        @required bool wholesale,
        @required BuildContext context,
        @required Function(String, int) onAddItem,
        @required Function(dynamic) onGetPrice,
        @required Function(String) onRemoveItem}) =>
    Column(
      children: [
        ListTile(
          title: Text(cart.product['product']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wholesale
                  ? Text(
                      '${cart.quantity} (x${cart.product['wholesaleQuantity']}) '
                      '@ TZS ${onGetPrice(cart.product)}')
                  : Text('${cart.quantity} '
                      '@ TZS ${onGetPrice(cart.product)}'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => onAddItem(cart.product['id'], -1),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => onAddItem(cart.product['id'], 1),
                  ),
                ],
              )
            ],
          ),
          isThreeLine: false,
          trailing: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () => onRemoveItem(cart.product['id']),
          ),
        ),
        const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Divider(color: Colors.grey))
      ],
    );

_cartListItemBuilder(carts, wholesale, onAddItem, onRemoveItem, onGetPrice) =>
    (context, index) => _checkoutCartItem(
        cart: carts[index],
        onGetPrice: onGetPrice,
        wholesale: wholesale,
        context: context,
        onAddItem: onAddItem,
        onRemoveItem: onRemoveItem);
