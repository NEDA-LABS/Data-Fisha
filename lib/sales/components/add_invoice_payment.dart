import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/api_invoice.dart';

addInvoicePaymentContent(String? id) => ActiveComponent(
    initialState: const {"loading": false},
    builder: (context, states, updateState) => Container(
      constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: ListBody(children: [
          TextInput(
              onText: (d) => updateState({'amount': d}),
              label: "Amount",
              type: TextInputType.number,
              error: states['error']??'',
              placeholder: ''),
          Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(children: [
                Expanded(
                    child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                            onPressed: states['loading']
                                ? null
                                : () => _submitAddInvoicePayment(
                                    id, states, updateState),
                            child: Text(
                                states['loading'] ? "Waiting..." : "Submit.",
                                style: const TextStyle(fontSize: 16)))))
              ])),
          Text(states['error'] ?? '')
        ]))));

_validateName(data) => data is String && data.isNotEmpty;

_submitAddInvoicePayment(String? id, Map<dynamic, dynamic> states,
    Function([Map? value]) updateState) {
  updateState({'error': ''});
  if (!_validateName(states['amount'])) {
    updateState({'error': 'Amount required'});
    return;
  }
  var payment = {'amount': doubleOrZero("${states['amount']}")};
  var patchInvoice = prepareAddPayment(id, payment);
  getActiveShop().then((shop) {
    updateState({'loading': true});
    patchInvoice(shop)
        .then((value) => navigator().maybePop())
        .catchError((onError) => updateState({'error': onError.toString()}))
        .whenComplete(() => updateState({'loading': false}));
  });
}
