import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/table_like_list.dart';

transferDetails(context, item) => ListView(
      shrinkWrap: true,
      children: [
        _header(context, item),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Text('Items',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ),
        _tableHeader(),
        ...item['items']
            .map<Widget>((item) => tableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text('${item['product']}')),
                  Text('${item['quantity']}')
                ]))
            .toList() as List<Widget>,
        Container(
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
            child: OutlinedButton(
                onPressed: () {
                  // navigator().maybePop().whenComplete(() {
                  //   showDialog(
                  //       context: context,
                  //       builder: (_) => Dialog(
                  //           child: addPurchasePaymentContent(item['id'])));
                  // });
                },
                child: const Text('Print.',
                    style: TextStyle(fontSize: 16)))),
        const SizedBox(height: 24)
      ],
    );

_tableHeader() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
    child: SizedBox(
        height: 38,
        child: tableLikeListRow([
          tableLikeListTextHeader('Product'),
          tableLikeListTextHeader('Quantity')
        ])));

_header(context, item) => Container(
    height: 50,
    color: Theme.of(context).primaryColorDark,
    padding: const EdgeInsets.all(16),
    child: Row(children: [
      const Expanded(
          child: Text('Transfer details',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 16))),
      Text('${_formDate(item['date'])}',
          style: const TextStyle(color: Colors.white, fontSize: 16))
    ]));

_formDate(d) {
  var f = DateFormat('yyyy-MM-dd HH:mm');
  return f.format(DateTime.parse(d));
}
