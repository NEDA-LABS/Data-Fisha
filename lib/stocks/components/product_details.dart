import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/offset_quantity_content.dart';
import 'package:smartstock/stocks/services/product.dart';

productDetail(Map item, context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.min,
      shrinkWrap: true,
        children: [
          ListTile(
              title: Text(item['product'] ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              dense: true,
              onTap: () {}),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                outlineButton(
                    onPressed: () {
                      navigator().maybePop().whenComplete(() {
                        navigator()
                            .pushNamed('/stock/products/edit', arguments: item);
                      });
                    },
                    title: 'Edit details'),
                outlineButton(
                    onPressed: () {
                      navigator().maybePop().whenComplete(() => showDialog(
                          context: context,
                          builder: (_) => Dialog(
                              child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 400),
                                  child: OffsetQuantityContent(
                                      productId: item['id'],
                                      product: item['product'])))));
                    },
                    title: 'Offset quantity'),
                // outlineButton(onPressed: (){}, title: 'Track quantity'),
                outlineButton(
                    onPressed: () {
                      navigator().maybePop().whenComplete(() {
                        showDialog(
                            context: context,
                            builder: (_) => deleteDialog(
                                message:
                                    'Delete of "${item['product']}" is permanent, do you wish to continue ? ',
                                onConfirm: () => deleteProduct(item['id'])));
                      });
                    },
                    title: 'Delete',
                    textColor: Colors.red)
              ])),
          ...item.keys
              .where((k) => k != 'product')
              .map((e) => listItem(e, item))
        ]));

listItem(e, item) => ListTile(
    title: Text('$e',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
    subtitle: Text('${item[e]}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    // onTap: () {},
    dense: true);
