import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/api_customer.dart';
import 'package:smartstock/sales/services/cache_customer.dart';


createCustomerContent() => ActiveComponent(
      initialState: const {"loading": false},
      builder: (context, states, updateState) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(children: [
            TextInput(
                onText: (d) => updateState({'displayName': d}),
                label: "Name",
                error: states['error_d']??'',
                placeholder: ''),
            TextInput(
                onText: (d) => updateState({'phone': d}),
                label: "Phone",
                error: states['error_p']??'',
                placeholder: '255XXXXXXXXX'),
            TextInput(
                onText: (d) => updateState({'email': d}),
                label: "Email",
                placeholder: "( Optional )"),
            // TextInput(
            //     onText: (d) => updateState({'company': d}),
            //     label: "Company",
            //     placeholder: "( Optional )"),
            TextInput(
                onText: (d) => updateState({'tin': d}),
                label: "TIN",
                placeholder: "( Optional )"),
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
                                  : () => _createCustomer(states, updateState),
                              child: Text(
                                states['loading']
                                    ? "Waiting..."
                                    : "Create Customer.",
                                style: const TextStyle(fontSize: 16),
                              ))))
                ])),
            Text(states['error'] ?? '')
          ]),
        ),
      ),
    );

_validateName(data) => data is String && data.isNotEmpty;

_validatePhone(data) => data is String && data.isNotEmpty;

_createCustomer(
    Map<dynamic, dynamic> states, Function([Map? value]) updateState) {
  updateState({'error_d': '', 'error_p': ''});
  if (!_validateName(states['displayName'])) {
    updateState({'error_d': 'Name required'});
    return;
  }
  if (!_validatePhone(states['phone'])) {
    updateState({'error_p': 'Phone number required'});
    return;
  }
  var customer = {
    'displayName': states['displayName'],
    'phone': states['phone'],
  };
  if (states['email'] != null) customer['email'] = states['email'];
  if (states['tin'] != null) customer['tin'] = states['tin'];
  var createCustomer = prepareCreateCustomer(customer);
  getActiveShop().then((shop) {
    updateState({'loading': true});
    createCustomer(shop)
        .then((value) {
          saveLocalCustomer(shopToApp(shop), customer);
          navigator().maybePop();
        })
        .catchError((onError) => updateState({'error': onError.toString()}))
        .whenComplete(() => updateState({'loading': false}));
  });
}
