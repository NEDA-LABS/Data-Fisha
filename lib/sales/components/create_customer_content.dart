import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';

import '../../core/components/text_input.dart';

createCustomerContent() => ActiveComponent(
      initialState: const {"loading": false},
      builder: (context, states, updateState) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(children: [
            TextInput(
                onText: (d) => updateState({'displayName': d}),
                label: "Name",
                error: states['err_displayName'],
                placeholder: ''),
            TextInput(
                onText: (d) => updateState({'phone': d}),
                label: "Phone",
                error: states['err_phone'],
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

_createCustomer(
    Map<dynamic, dynamic> states, Function([Map value]) updateState) {}
