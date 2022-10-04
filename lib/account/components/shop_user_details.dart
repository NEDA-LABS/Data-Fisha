import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/services/util.dart';

shopUserDetail(Map item, context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(shrinkWrap: true, children: [
      ListTile(
          title: Text(item['username'] ?? '',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          dense: true,
          onTap: null),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            // outlineActionButton(
            //     onPressed: () => navigator().maybePop().whenComplete(() =>
            //         navigator()
            //             .pushNamed('/account/products/edit', arguments: item)),
            //     title: 'Edit details'),
            outlineActionButton(
                onPressed: () {
                  // navigator().maybePop().whenComplete(() => showDialog(
                  //     context: context,
                  //     builder: (_) => Dialog(
                  //         child: Container(
                  //             constraints: const BoxConstraints(maxWidth: 400),
                  //             child: OffsetQuantityContent(
                  //                 productId: item['id'],
                  //                 product: item['product'])))));
                },
                title: 'Update password'),
            // outlineActionButton(
            //     onPressed: () => navigator().maybePop().whenComplete(() =>
            //         showDialogOrModalSheet(
            //             ProductMovementDetails(item: item), context)),
            //     title: 'Track movement'),
            outlineActionButton(
                onPressed: () {
                  // navigator().maybePop().whenComplete(() {
                  //   showDialog(
                  //       context: context,
                  //       builder: (_) => DeleteDialog(
                  //           message:
                  //               'Delete of "${item['username']}" is permanent, do you wish to continue ? ',
                  //           onConfirm: () => deleteProduct(item['id'])));
                  // });
                },
                title: 'Delete',
                textColor: Colors.red)
          ])),
      ...item.keys.where((k) => k != 'product').map((e) => _listItem(e, item))
    ]));

_listItem(e, item) => ListTile(
    title: Text('$e',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
    subtitle: Text('${item[e]}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    // onTap: () {},
    dense: true);
