import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/sales/services/api_invoice.dart';

class SaleInvoiceRefundContent extends StatefulWidget {
  final dynamic saleId;
  final dynamic item;

  const SaleInvoiceRefundContent(this.saleId, this.item, {super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleInvoiceRefundContent> {
  Map states = {};
  var updateState;

  @override
  void initState() {
    states = {
      "loading": false,
      'amount': '${propertyOr('amount_refund', (p0) => 0)(widget.item)}',
      'quantity': '${propertyOr('quantity_refund', (p0) => 0)(widget.item)}',
      'product':
          compose([propertyOr('product', (p0) => ''), propertyOrNull('stock')])(
              widget.item),
      'batch': propertyOr('batch', (p0) => '')(widget.item),
    };
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
            _submitButton(context, states, updateState),
            Text(states['error'] ?? '')
          ],
        ),
      ),
    );
  }

  _validateName(data) => data is String && data.isNotEmpty;

  _submitButton(context, states, updateState) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton(
        onPressed: states['loading'] == true
            ? null
            : () => _submitRefund(states, updateState),
        child: Text(
          states['loading'] ? "Waiting..." : "Submit.",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _submitRefund(states, updateState) {
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
      'product': states['product'] ?? '',
      'batch': states['batch'] ?? '',
    };
    var invoiceRefund = prepareInvoiceRefund(widget.saleId, refund);
    updateState({'loading': true});
    getActiveShop()
        .then((shop) => invoiceRefund(shop))
        .then((value) => Navigator.of(context).maybePop())
        .catchError((onError) => updateState({'error': onError.toString()}))
        .whenComplete(() => updateState({'loading': false}));
  }
}
