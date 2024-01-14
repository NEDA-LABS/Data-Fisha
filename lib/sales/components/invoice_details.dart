import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/components/add_invoice_payment.dart';

invoiceDetails(context, item) => ListView(
      shrinkWrap: true,
      children: [
        _header(context, item),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Text('Items',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ),
        _tableHeader(),
        ...itOrEmptyArray(item['items'])
            .map<Widget>((item) => TableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text('${item['stock']['product']}')),
                  Text('${item['quantity']}'),
                  Text('${item['amount']}'),
                ]))
            .toList() as List<Widget>,
        _getPayments(item['payments']).isNotEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Text('Payments',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              )
            : Container(),
        ...itOrEmptyArray(_getPayments(item['payments']))
            .map<Widget>((item) => TableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text('${_formatDate(item['date'] ?? '')}')),
                  const Text(''),
                  Text('${formatNumber(item['amount'])}'),
                ]))
            .toList(),
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
            child: const Text('Add payment', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 24,)
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
              child: Text(
            '#${item['id']}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )),
          Text(
            '${item['date']}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
