import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/expense/components/create_item_content.dart';
import 'package:smartstock/expense/services/items.dart';

class ExpenseItemsPage extends StatefulWidget {
  const ExpenseItemsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseItemsPage> {
  String _query = '';
  bool _isLoading = false;
  List _categories = [];

  @override
  void initState() {
    _fetchCategories(false);
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        menus: moduleMenus(),
        current: '/expense/',
        sliverAppBar: _appBar(context),
        onBody: (d) => Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextItems(context)),
              _loading(_isLoading),
              _tableHeader(),
              Expanded(
                child: TableLikeList(
                    onFuture: () async => _categories, keys: _fields()
                    // onCell: (key,data)=>Text('@$data')
                    ),
              ),
              // _tableFooter()
            ],
          ),
        ),
      );

  _appBar(context) {
    return StockAppBar(
      title: "Expense items",
      showBack: true,
      backLink: '/expense/',
      showSearch: true,
      onSearch: (p0) {
        setState(() {
          _query = p0;
        });
      },
      searchHint: 'Search...', context: context,
    );
  }

  _contextItems(context) {
    return [
      ContextMenu(
        name: 'Add',
        pressed: () {
          showDialog(
            context: context,
            builder: (c) => Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: const Dialog(
                  child: CreateExpenseItemContent(),
                ),
              ),
            ),
          ).whenComplete(() => _fetchCategories(true));
        },
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetchCategories(true);
        },
      ),
    ];
  }

  _tableHeader() => TableLikeListRow([
        TableLikeListTextHeaderCell('Name'),
        TableLikeListTextHeaderCell('Category'),
      ]);

  _fields() => ['name', 'category'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  void _fetchCategories(bool remote) {
    setState(() {
      _isLoading = true;
    });
    getExpenseItemFromCacheOrRemote(skipLocal: remote, stringLike: _query)
        .then((value) {
      _categories = value;
    }).catchError((err) {
      showInfoDialog(context, '$err', title: 'Error');
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
