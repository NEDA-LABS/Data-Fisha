import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/api_purchase.dart';

class AddPurchasePaymentContent extends StatefulWidget {
  final String? id;

  const AddPurchasePaymentContent(this.id, {super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddPurchasePaymentContent> {
  Map states = {"loading": false};
  dynamic updateState;

  @override
  void initState() {
    updateState = ifDoElse(
        (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(
            children: [
              TextInput(
                  onText: (d) => updateState({'amount': d}),
                  label: "Amount",
                  type: TextInputType.number,
                  error: states['error_q'] ?? '',
                  placeholder: ''),
              Container(
                height: 64,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                                onPressed: states['loading']
                                    ? null
                                    : () => _submitAddPurchasePayment(
                                        widget.id, states, updateState),
                                child: Text(
                                    states['loading']
                                        ? "Waiting..."
                                        : "Submit.",
                                    style: const TextStyle(fontSize: 16)))))
                  ],
                ),
              ),
              Text(states['error'] ?? '',
                  style: const TextStyle(color: Colors.red))
            ],
          ),
        ),
      ),
    );
  }

  _validateName(data) => data is String && data.isNotEmpty;

  _submitAddPurchasePayment(
    String? id,
    Map<dynamic, dynamic> states,
    updateState,
  ) {
    updateState({'error': '', 'error_q': ''});
    if (!_validateName(states['amount'])) {
      updateState({'error_q': 'Amount required'});
      return;
    }
    var payment = {'amount': doubleOrZero("${states['amount']}")};
    getActiveShop().then((shop) {
      updateState({'loading': true});
      productsPurchasePaymentAddRestAPI(id ?? '', payment, shop)
          .then((value) => Navigator.of(context).maybePop())
          .catchError((onError) => updateState({'error': onError.toString()}))
          .whenComplete(() => updateState({'loading': false}));
    });
  }
}
