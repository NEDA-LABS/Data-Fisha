import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_purchase.dart';

addPurchasePaymentContent(String id) => Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: ActiveComponent(
          initialState: const {"loading": false},
          builder: (context, states, updateState) => Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                  child: ListBody(children: [
                TextInput(
                    onText: (d) => updateState({'amount': d}),
                    label: "Amount",
                    type: TextInputType.number,
                    error: states['error_q'],
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
                                      : () => _submitAddPurchasePayment(
                                          id, states, updateState),
                                  child: Text(
                                      states['loading']
                                          ? "Waiting..."
                                          : "Submit.",
                                      style: const TextStyle(fontSize: 16)))))
                    ])),
                Text(states['error'] ?? '',
                    style: const TextStyle(color: Colors.red))
              ])))),
    );

_validateName(data) => data is String && data.isNotEmpty;

_submitAddPurchasePayment(
  String id,
  Map<dynamic, dynamic> states,
  Function([Map value]) updateState,
) {
  updateState({'error': '', 'error_q': ''});
  if (!_validateName(states['amount'])) {
    updateState({'error_q': 'Amount required'});
    return;
  }
  var payment = {'amount': double.tryParse("${states['amount']}") ?? 0};
  var patchPurchase = preparePatchPurchasePayment(id, payment);
  getActiveShop().then((shop) {
    updateState({'loading': true});
    patchPurchase(shop)
        .then((value) => navigator().maybePop())
        .catchError((onError) => updateState({'error': onError.toString()}))
        .whenComplete(() => updateState({'loading': false}));
  });
}
