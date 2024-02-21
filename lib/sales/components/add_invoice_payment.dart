import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/services/api_invoice.dart';

class AddInvoicePaymentContent extends StatefulWidget {
  final String? id;

  const AddInvoicePaymentContent(this.id, {super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddInvoicePaymentContent> {
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
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            TextInput(
                onText: (d) => updateState({'amount': d}),
                label: "Amount",
                type: TextInputType.number,
                error: states['error'] ?? '',
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
                            : () => _submitAddInvoicePayment(
                                widget.id, states, updateState),
                        child: BodyLarge(
                          text: states['loading'] ? "Waiting..." : "Submit."
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            BodyLarge(text: states['error'] ?? '')
          ],
        ),
      ),
    );
  }

  _validateName(data) => data is String && data.isNotEmpty;

  _submitAddInvoicePayment(
      String? id, Map<dynamic, dynamic> states, updateState) {
    updateState({'error': ''});
    if (!_validateName(states['amount'])) {
      updateState({'error': 'Amount required'});
      return;
    }
    var payment = {'amount': doubleOrZero("${states['amount']}")};
    var patchInvoice = prepareAddInvoicePayment(id, payment);
    getActiveShop().then((shop) {
      updateState({'loading': true});
      patchInvoice(shop)
          .then((value) => Navigator.of(context).maybePop())
          .catchError((onError) => updateState({'error': onError.toString()}))
          .whenComplete(() => updateState({'loading': false}));
    });
  }
}
