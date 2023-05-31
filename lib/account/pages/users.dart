import 'package:flutter/material.dart';
import 'package:smartstock/account/components/shop_user_details.dart';
import 'package:smartstock/account/pages/user_create.dart';
import 'package:smartstock/account/services/shop_users.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

class UsersPage extends StatefulWidget {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const UsersPage({
    required this.onBackPage,
    required this.onChangePage,
    Key? key,
  }) : super(key: key);

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
  Widget build(context) => ResponsivePage(
        current: '/account/',
        sliverAppBar: _appBar(context),
        staticChildren: [
          _loading(loading),
          getIsSmallScreen(context)
              ? Container()
              : tableContextMenu(_contextItems()),
          _tableHeader(),
        ],
        totalDynamicChildren: users.length,
        fab: FloatingActionButton(
          onPressed: () => _showMobileContextMenu(context),
          child: const Icon(Icons.unfold_more_outlined),
        ),
        dynamicChildBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {
                  showDialogOrModalSheet(
                      shopUserDetail(users[index], context), context);
                },
                child: TableLikeListRow([
                  TableLikeListTextDataCell('${users[index]['username']}'),
                  TableLikeListTextDataCell('${users[index]['role']}'),
                ]),
              ),
              const HorizontalLine()
            ],
          );
        },
      );

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Users",
      showBack: true,
      // backLink: '/account/',
      onBack: widget.onBackPage,
      showSearch: false,
      context: context,
      // onSearch: (p0) {},
      // searchHint: 'Search...',
    );
  }

  _contextItems() {
    return [
      ContextMenu(
        name: 'Add',
        pressed: () => widget
            .onChangePage(ShopUserCreatePage(onBackPage: widget.onBackPage)),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetch();
        },
      ),
    ];
  }

  _tableHeader() {
    return const TableLikeListRow([
      TableLikeListTextHeaderCell('Name'),
      TableLikeListTextHeaderCell('Role'),
    ]);
  }

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

  void _showMobileContextMenu(context) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Create user'),
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShopUserCreatePage(
                              onBackPage: widget.onBackPage,
                            ),
                          ),
                        ),
                      );
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload users'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _fetch();
                },
              ),
            ],
          ),
        ),
        context);
  }
}
