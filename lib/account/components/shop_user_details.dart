import 'package:flutter/material.dart';
import 'package:smartstock/account/components/update_user_password_content.dart';
import 'package:smartstock/account/services/shop_users.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/helpers/util.dart';

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
            outlineActionButton(
              onPressed: () {
                Navigator.of(context).maybePop().whenComplete(
                  () {
                    return showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: UpdateUserPasswordContent(
                              userId: item['id'],
                              password: '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              title: 'Update password',
            ),
            outlineActionButton(
                onPressed: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    showDialog(
                        context: context,
                        builder: (_) => DeleteDialog(
                            message:
                                'Delete of "${item['username']}" is permanent, do you wish to continue ? ',
                            onConfirm: () => deleteUser(item['id'])));
                  });
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
