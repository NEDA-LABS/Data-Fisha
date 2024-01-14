import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/with_active_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/components/add_invoice_payment.dart';

orderDetails(context, item) {
  return ListView(
    shrinkWrap: true,
    children: [
      _header(context, item),
      // const Padding(
      //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      //   child: Text('Items',
      //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
      // ),
      const HorizontalLine(),
      const WhiteSpacer(height: 8),
      _tableHeader(),
      ...itOrEmptyArray(item['carts']).map<Widget>((item) {
        return TableLikeListRow([
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            width: 100,
            height: 100,
            alignment: AlignmentDirectional.topStart,
            child: Image.network('${item['images']}'.split(',')[0]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: BodyLarge(text: firstLetterUpperCase('${item['product']}')),
          ),
          BodyLarge(text: '${item['quantity']}'),
          WithActiveShop(
            onChild: (shop) {
              return BodyLarge(
                  text:
                      "${shop['settings']?['currency'] ?? 'TZS'} ${formatNumber('${item['unit_price']}')}");
            },
          ),
        ]);
      }).toList(),
      const SizedBox(height: 24)
    ],
  );
}

_tableHeader() => const Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
      child: SizedBox(
        height: 38,
        child: TableLikeListRow([
          TableLikeListHeaderCell('Image'),
          TableLikeListHeaderCell('Product'),
          TableLikeListHeaderCell('Quantity'),
          TableLikeListHeaderCell('Amount')
        ]),
      ),
    );

_header(context, item){
  return Container(
    height: 50,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Expanded(
            child: BodyLarge(
              text: 'Order #${item['id']}',
              overflow: TextOverflow.ellipsis,
            )),
        BodyLarge(text: '${item['date']}'),
      ],
    ),
  );
}
