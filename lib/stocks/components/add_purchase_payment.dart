import 'package:flutter/material.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/purchase.dart';

class AddPurchasePaymentContent extends StatefulWidget {
  final void Function(Map payment) onDone;
  final Map purchase;

  const AddPurchasePaymentContent(
      {required this.purchase, required this.onDone, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddPurchasePaymentContent> {
  final Map _states = {"loading": false, 'mode': 'CASH'};
  dynamic _updateState;

  @override
  void initState() {
    _updateState = ifDoElse((x) => x is Map && mounted,
        (x) => setState(() => _states.addAll(x)), (x) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BodyLarge(text: 'Add payment for purchase #${widget.purchase['id']}'),
              TextInput(
                onText: (d) => _updateState({'amount': d, 'error_amount': ''}),
                label: "Amount",
                type: TextInputType.number,
                error: _states['error_amount'] ?? '',
              ),
              ChoicesInput(
                onChoice: (p0) {
                  _updateState({'mode': p0});
                },
                label: 'Payment method',
                choice: _states['mode'],
                onLoad: ([skipLocal = false]) async {
                  return [
                    'CASH',
                    'M-PESA',
                    'TIGOPESA',
                    'AIRTEL',
                    'HALOPESA',
                    'BANK'
                  ];
                },
                onField: (p0) => p0 ?? '',
              ),
              TextInput(
                onText: (d) => _updateState({'reference': d}),
                label: "Reference",
                placeholder: 'Optional',
                type: TextInputType.number,
                error: _states['error_reference'] ?? '',
              ),
              const WhiteSpacer(height: 16),
              CancelProcessButtonsRow(
                cancelText: 'Cancel',
                proceedText: _states['loading'] == true
                    ? 'Processing...'
                    : 'Add payment',
                onProceed: _states['loading'] == true
                    ? null
                    : _submitAddPurchasePayment,
                onCancel: () => Navigator.of(context).maybePop(),
              )
              // Text(_states['error'] ?? '',
              //     style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  _validateAmount(data) => doubleOrZero(data) !=0;

  void _submitAddPurchasePayment() {
    _updateState({'error': '', 'error_amount': ''});
    if (!_validateAmount(_states['amount'])) {
      _updateState(
          {'error_amount': 'Amount required and must be greater or less than zero'});
      return;
    }
    Map payment = {
      'amount': doubleOrZero("${_states['amount']}"),
      'mode': _states['mode'],
      'reference': _states['reference'] ?? ''
    };
    _updateState({'loading': true});
    var id = widget.purchase['id'];
    productsPurchasePaymentAdd(id: id, payment: payment).then((value) {
      widget.onDone(payment);
      Navigator.of(context).maybePop().whenComplete(() {
        showInfoDialog(context, 'Payment added to purchase invoice');
      });
      // Navigator.of(context).maybePop();
    }).catchError((onError) {
      showInfoDialog(context, onError);
    }).whenComplete(() {
      _updateState({'loading': false});
    });
  }
}
