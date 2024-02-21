import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/components/add_invoice_payment.dart';

invoiceDetails(context, item) => ListView(
      shrinkWrap: true,
      children: [
        _header(context, item),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: TitleMedium(text: 'Items'),
        ),
        _tableHeader(),
        ...itOrEmptyArray(item['items'])
            .map<Widget>((item) => TableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: BodyLarge(text: '${item['stock']['product']}')),
                  BodyLarge(text: '${item['quantity']}'),
                  BodyLarge(text: '${item['amount']}'),
                ])),
        _getPayments(item['payments']).isNotEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: BodyLarge(text: 'Payments'),
              )
            : Container(),
        ...itOrEmptyArray(_getPayments(item['payments'])).map<Widget>((item) =>
            TableLikeListRow([
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: BodyLarge(text: '${_formatDate(item['date'] ?? '')}')),
              BodyLarge(text: '${formatNumber(item['amount'])}'),
            ])),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).maybePop().whenComplete(() {
                showDialog(
                    context: context,
                    builder: (_) =>
                        Dialog(child: AddInvoicePaymentContent(item['id'])));
              });
            },
            child: const BodyLarge(text: 'Add payment'),
          ),
        ),
        const SizedBox(
          height: 24,
        )
      ],
    );

_formatDate(d) => DateFormat('yyyy-MM-dd HH:mm')
    .format((DateTime.tryParse(d) ?? DateTime.now()).toLocal());

List _getPayments(item) {
  if (item is List) {
    return item;
  }
  return [];
}

_tableHeader() => const Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
      child: SizedBox(
        height: 38,
        child: TableLikeListRow([
          TableLikeListHeaderCell('Product'),
          TableLikeListHeaderCell('Quantity'),
          TableLikeListHeaderCell('Amount ( TZS )')
        ]),
      ),
    );

_header(context, item) => Container(
      height: 50,
      color: Theme.of(context).primaryColorDark,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: BodyLarge(
            text: '#${item['id']}',
            overflow: TextOverflow.ellipsis,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
          BodyLarge(
              text: '${item['date']}',
              color: Theme.of(context).colorScheme.onPrimary)
        ],
      ),
    );
