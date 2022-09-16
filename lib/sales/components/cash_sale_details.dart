import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/offset_quantity_content.dart';
import 'package:smartstock/stocks/components/product_movement.dart';
import 'package:smartstock/stocks/services/product.dart';

cashSaleDetail(context, Map sale) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(shrinkWrap: true, children: [
      ListTile(
          title: Text(sale['product'] ?? '',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          dense: true,
          onTap: () {}),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            outlineButton(onPressed: () {}, title: 'Refund'),
            outlineButton(onPressed: () {}, title: 'Clear refund'),
          ])),
      ...sale.keys.where((k) => k != 'product').map((e) => _listItem(e, sale))
    ]));

_listItem(e, item) => ListTile(
    title: Text('$e',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
    subtitle: Text('${item[e]}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    // onTap: () {},
    dense: true);
