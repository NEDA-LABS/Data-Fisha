import 'package:flutter/material.dart';
import 'package:smartstock/account/components/update_user_password_content.dart';
import 'package:smartstock/account/services/shop_users.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/helpers/util.dart';

shopUserDetail(Map item, context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(shrinkWrap: true, children: [
      ListTile(
          title: TitleMedium(text: item['username'] ?? ''),
          dense: true,
          onTap: null),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            MenuContextAction(
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
            MenuContextAction(
                onPressed: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    showDialog(
                        context: context,
                        builder: (_) => DeleteDialog(
                          onDone: (p0) {
                            Navigator.of(context).maybePop();
                          },
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
    title: BodyLarge(text: '$e'),
    subtitle: BodyLarge(text: '${item[e]}'),
    // onTap: () {},
    dense: true);
