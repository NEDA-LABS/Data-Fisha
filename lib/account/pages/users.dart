import 'package:flutter/material.dart';
import 'package:smartstock/account/components/shop_user_details.dart';
import 'package:smartstock/account/services/shop_users.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<UsersPage> {
  var loading = false;
  var users = [];

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/account/',
        onBody: (d) => Scaffold(
          drawer: d,
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _loading(loading),
              tableContextMenu(_contextItems()),
              _tableHeader(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableLikeList(
                  onFuture: () async => users,
                  keys: _fields(),
                  onItemPressed: (item) {
                    showDialogOrModalSheet(
                        shopUserDetail(item, context), context);
                  },
                  // onCell: (key, data, c) {
                  //   if (key == 'product') return Text('$data');
                  //   return Text('${doubleOrZero(data)}');
                  // },
                ),
              )
              // _tableFooter()
            ],
          ),
        ),
      );

  _appBar(context) {
    return StockAppBar(
      title: "Users",
      showBack: true,
      backLink: '/account/',
      showSearch: false,
      // onSearch: (p0) {},
      // searchHint: 'Search...',
    );
  }

  _contextItems() {
    return [
      ContextMenu(
          name: 'Add', pressed: () => navigateTo('/account/users/create')),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetch();
        },
      ),
    ];
  }

  _tableHeader() {
    return tableLikeListRow([
      tableLikeListTextHeader('Name'),
      tableLikeListTextHeader('Role'),
    ]);
  }

  _fields() => ['username', 'role'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  _fetch() {
    setState(() {
      loading = true;
    });
    getShopUsers().then((value) {
      users = value is List ? value : [];
    }).catchError((err) {
      showInfoDialog(context, err);
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
