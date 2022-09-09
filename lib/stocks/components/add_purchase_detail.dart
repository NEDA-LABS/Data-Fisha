import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';

Future addPurchaseDetail({
  @required BuildContext context,
  @required onSubmit,
}) =>
    showDialog(
      context: context,
      builder: (c) => Dialog(
        child: ActiveComponent(
          initialState: const {
            "reference": '',
            "type": 'receipt',
            'date': '',
            'due': ''
          },
          builder: (context, states, updateState) => Wrap(
            children: [
              Container(
                decoration: _addToCartBoxDecoration(),
                // height: 230,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                          title: const Text("Is this invoice purchased?"),
                          value: states['type'] == 'invoice',
                          onChanged: (b) => b
                              ? updateState({'type': 'invoice'})
                              : updateState({'type': 'receipt'})),
                    ),
                    TextInput(
                        label: 'Purchase reference',
                        initialText: '${states['reference']}',
                        lines: 1,
                        error: states['error_r'],
                        type: TextInputType.text,
                        onText: (v) => updateState({'reference': v})),
                    DateInput(
                      label: 'Purchase date',
                      onText: (d) => updateState({'date': d}),
                      error: states['error_d'],
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 360)),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                    ),
                    states['type'] == 'invoice'
                        ? DateInput(
                            label: 'Payment due date',
                            onText: (d) => updateState({'due': d}),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 360)),
                            initialDate: DateTime.now(),
                          )
                        : Container(),
                    _addToCartButton(context, states, updateState, onSubmit),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

_addToCartButton(context, states, updateState, onSubmit) => Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    height: 40,
    width: MediaQuery.of(context).size.width,
    child: TextButton(
        onPressed: () {
          updateState({'error_r': '', 'error_d': ''});
          if ('${states['reference'] ?? ''}'.isEmpty) {
            updateState({'error_r': 'Reference required'});
            return;
          }
          if ('${states['date'] ?? ''}'.isEmpty) {
            updateState({'error_d': 'Purchase date required'});
            return;
          }
          onSubmit(states);
        },
        style: _addToCartButtonStyle(context),
        child: const Text("SUBMIT", style: TextStyle(color: Colors.white))));

_addToCartButtonStyle(context) => ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(Theme.of(context).primaryColorDark));

_addToCartBoxDecoration() => const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );
