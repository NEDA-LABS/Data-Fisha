import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_expense_content.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/components/bottom_bar.dart';
import '../services/expenses.dart';

class ExpenseExpensesPage extends StatefulWidget {
  const ExpenseExpensesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseExpensesPage> {
  bool _loading = false;
  int size = 20;
  List _expenses = [];

  _onItemPressed(item) {
    // showDialogOrModalSheet(
    //     CashSaleDetail(sale: item, pageContext: context), context);
  }

  Widget _onCell(a, b, c) {
    if (a == 'name') {
      return _itemView(c);
    }
    if (a == 'amount') {
      var numberFormat = NumberFormat.simpleCurrency(name: '');
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(numberFormat.format(doubleOrZero(b))),
      );
    }
    // if (a == 'name') {
    //   return Text('${doubleOrZero(_itemsSize(c))}');
    // }
    return Text('$b');
  }

  _contextSales(context) {
    return [
      ContextMenu(
        name: 'Add',
        pressed: () {
          isSmallScreen(context)
              ? fullScreeDialog(
                  context,
                  (p0) => Scaffold(
                        appBar: AppBar(
                          title: const Text("New expense"),
                        ),
                        body: const CreateExpenseContent(),
                      )).whenComplete(() => _refresh())
              : showDialog(
                  context: context,
                  builder: (c) => Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const Dialog(
                        child: CreateExpenseContent(),
                      ),
                    ),
                  ),
                ).whenComplete(() => _refresh());
        },
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    var height = 38.0;
    var smallView = SizedBox(
      height: height,
      child: tableLikeListRow([
        tableLikeListTextHeader('Item'),
        tableLikeListTextHeader('Category'),
        tableLikeListTextHeader('Amount ( TZS )'),
      ]),
    );
    // var bigView = SizedBox(
    //   height: height,
    //   child: tableLikeListRow([
    //     tableLikeListTextHeader('Item'),
    //     tableLikeListTextHeader('Categ'),
    //     tableLikeListTextHeader('Amount ( TZS )'),
    //     tableLikeListTextHeader('Category'),
    //   ]),
    // );
    return smallView;
  }

  _fields() => ['name', 'category', 'amount'];

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      menus: moduleMenus(),
      current: '/expense/',
      sliverAppBar: StockAppBar(title: "Expenses", showBack: false, context: context),
      onBody: (d) {
        return Scaffold(
          drawer: d,
          body: _body(),
          bottomNavigationBar: bottomBar(3, moduleMenus(), context),
        );
      },
    );
  }

  _loadMore() {
    setState(() {
      _loading = true;
    });
    var getExp = _prepareGetExpenses(size, true);
    getExp(_expenses).then((value) {
      if (value is List) {
        _expenses.addAll(value);
        _expenses = _expenses.toSet().toList();
        setState(() {});
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _refresh() {
    setState(() {
      _loading = true;
    });
    var getExp = _prepareGetExpenses(size, false);
    getExp(_expenses).then((value) {
      if (value is List) {
        _expenses = value;
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _defaultLast() {
    var dF = DateFormat('yyyy-MM-ddTHH:mm');
    var date = DateTime.now().add(const Duration(days: 1));
    return dF.format(date);
  }

  _prepareGetExpenses(size, bool more) {
    return ifDoElse(
      (x) => x is List && x.isNotEmpty,
      (x) {
        var last = more ? x.last['timer'] : _defaultLast();
        return getExpenses(last, size);
      },
      (_) => getExpenses(_defaultLast(), size),
    );
  }

  Widget _itemView(item) {
    var textStyle = const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
        height: 2.0,
        overflow: TextOverflow.ellipsis);
    var mainTextStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis);
    var dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    var dateTime = DateTime.parse(item['timer']);
    var subText =
        "${dateFormat.format(dateTime)} | ${timeago.format(dateTime)}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item['name'], style: mainTextStyle),
          Text(subText, style: textStyle)
        ],
      ),
    );
  }

  _salesList() {
    return Expanded(
      child: TableLikeList(
        onFuture: () async => _expenses,
        keys: _fields(),
        onCell: _onCell,
        onItemPressed: _onItemPressed,
        onLoadMore: _expenses.length >= size ? () async => _loadMore() : null,
        loading: _loading,
      ),
    );
  }

  _body() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _loadingView(_loading),
          tableContextMenu(_contextSales(context)),
          _tableHeader(),
          _salesList(),
        ],
      ),
    );
  }
}
