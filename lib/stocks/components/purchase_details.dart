import 'package:flutter/material.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/add_purchase_payment.dart';

purchaseDetails(context, item) => ListView(
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
            .map<Widget>((item) => TableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text('${item['product']}')),
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
        ..._getPayments(item['payments'])
            .map<Widget>((item) => TableLikeListRow([
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text('${item['date']}')),
                  const Text(''),
                  Text('${item['amount']}'),
                ]))
            .toList(),
        item['type'] == 'cash' || item['type'] == 'receipt'
            ? Container()
            : Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                child: OutlinedButton(
                    onPressed: () {
                      navigator().maybePop().whenComplete(() {
                        showDialog(
                            context: context,
                            builder: (_) => Dialog(
                                child: AddPurchasePaymentContent(item['id'])));
                      });
                    },
                    child: const Text('Add payment',
                        style: TextStyle(fontSize: 16)))),
        const SizedBox(height: 24)
      ],
    );

List _getPayments(item) {
  return item;
  // if (item is List<Map<String, dynamic>>) {
  //   return item;
  //   // return item.map((e) => ({"date": e, "amount": item[e]})).toList();
  // }
  // return [];
}

_tableHeader() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
      child: SizedBox(
        height: 38,
        child: TableLikeListRow([
          TableLikeListTextHeaderCell('Product'),
          TableLikeListTextHeaderCell('Quantity'),
          TableLikeListTextHeaderCell('Amount ( TZS )')
        ]),
      ),
    );

_header(context, item) => Container(
      height: 50,
      color: Theme.of(context).primaryColorDark,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
              child: Text(
            'Purchase details',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
          Text(
            '${item['date']}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
