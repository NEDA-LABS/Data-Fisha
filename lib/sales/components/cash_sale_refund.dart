import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/api_cash_sale.dart';

cashSaleRefundContent(sale) {
  Map states = {
    "loading": false,
    'amount': '0',
    'quantity': '0',
    'product': sale['product'] ?? ''
  };
  return StatefulBuilder(
    builder: (context, setState){
      // updateState(map){
      //   map is Map ? setState((){
      //     states.addAll(map);
      //   }): null;
      // }
      var updateState = ifDoElse((x) => x is Map, (x) =>
          setState(() => states.addAll(x)), (x) => null);
      return Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(
            children: [
              TextInput(
                  onText: (d) => updateState({'amount': d, 'e_a': ''}),
                  label: "Amount",
                  type: TextInputType.number,
                  initialText: states['amount'] ?? '0',
                  error: states['e_a'] ?? '',
                  placeholder: ''),
              TextInput(
                  onText: (d) => updateState({'quantity': d, 'e_q': ''}),
                  label: "Quantity",
                  type: TextInputType.number,
                  initialText: states['quantity'] ?? '0',
                  error: states['e_q'] ?? '',
                  placeholder: ''),
              _submitButton(context, sale['id'] ?? '', states, updateState),
              Text(states['error'] ?? '')
            ],
          ),
        ),
      );
    },
  );
}

_validateName(data) => data is String && data.isNotEmpty;

_submitButton(context, id, states, updateState) {
  return Container(
    height: 40,
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: OutlinedButton(
      onPressed: states['loading'] == true
          ? null
          : () => _submitRefund(id, states, updateState),
      child: Text(
        states['loading'] ? "Waiting..." : "Submit.",
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}

_submitRefund(String id, states, updateState) {
  if (!_validateName(states['amount'])) {
    updateState({'e_a': 'Amount required'});
  }
  if (!_validateName(states['quantity'])) {
    updateState({'e_q': 'Quantity required'});
    return;
  }
  var refund = {
    'amount': doubleOrZero(states['amount']),
    'quantity': doubleOrZero(states['quantity']),
    'product': states['product']??'',
  };
  var cashRefund = prepareCashRefund(id, refund);
  updateState({'loading': true});
  getActiveShop()
      .then((shop) => cashRefund(shop))
      .then((value) => navigator().maybePop())
      .catchError((onError) => updateState({'error': onError.toString()}))
      .whenComplete(() => updateState({'loading': false}));
}
