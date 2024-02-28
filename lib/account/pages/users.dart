import 'package:flutter/material.dart';
import 'package:smartstock/account/components/shop_user_details.dart';
import 'package:smartstock/account/pages/user_create.dart';
import 'package:smartstock/account/services/shop_users.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';

class UsersPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const UsersPage({
    required this.onBackPage,
    required this.onChangePage,
    Key? key,
  }) : super(key: key, pageName: 'UsersPage');

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        sliverAppBar: _appBar(context),
        staticChildren: [
          _loading(loading),
          getIsSmallScreen(context)
              ? Container()
              : getTableContextMenu(_contextItems()),
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
    return SliverSmartStockAppBar(
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
      TableLikeListHeaderCell('Name'),
      TableLikeListHeaderCell('Role'),
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
      showTransactionCompleteDialog(context, err,canDismiss: true,title: 'Error');
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
                title: BodyLarge(text: 'Create user'),
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(
                    () {
                      widget.onChangePage(
                        ShopUserCreatePage(onBackPage: widget.onBackPage),
                      );
                    },
                  );
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload users'),
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
