import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/transfer.dart';

transferDetails(context, item) => ListView(
      shrinkWrap: true,
      children: [
        _header(context, item),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: TitleMedium(text: 'Items'),
        ),
        _tableHeader(),
        ...item['items']
            .map<Widget>((item) => TableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: BodyLarge(text: '${item['product']}')),
                  BodyLarge(text: '${item['quantity']}')
                ]))
            .toList() as List<Widget>,
        Container(
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
            child: OutlinedButton(
                onPressed: () {
                  var getIsReceive =
                      compose([(x) => x == 'receive', propertyOrNull('type')]);
                  if (getIsReceive(item)) {
                    printPreviousReceiveTransfer(item);
                  } else {
                    printPreviousSendTransfer(item);
                  }
                },
                child: const BodyLarge(text: 'Print'))),
        const SizedBox(height: 24)
      ],
    );

_tableHeader() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
    child: SizedBox(
        height: 38,
        child: TableLikeListRow([
          TableLikeListHeaderCell('Product'),
          TableLikeListHeaderCell('Quantity')
        ])));

_header(context, item) => Container(
    height: 50,
    color: Theme.of(context).primaryColorDark,
    padding: const EdgeInsets.all(16),
    child: Row(children: [
      const Expanded(
          child: BodyLarge(
              text: 'Transfer details', overflow: TextOverflow.ellipsis)),
      BodyLarge(text: '${_formDate(item['date'])}',color: Theme.of(context).colorScheme.onPrimary,)
    ]));

_formDate(d) {
  var f = DateFormat('yyyy-MM-dd HH:mm');
  return f.format(DateTime.parse(d));
}
