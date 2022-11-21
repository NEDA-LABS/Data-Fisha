import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../services/expenses.dart';

class ExpenseExpensesPage extends StatefulWidget {
  const ExpenseExpensesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseExpensesPage> {
  bool _loading = false;
  String _query = '';
  int size = 20;
  List _expenses = [];

  _onItemPressed(item) {
    // showDialogOrModalSheet(
    //     CashSaleDetail(sale: item, pageContext: context), context);
  }

  Widget _onCell(a, b, c) {
    if (a == 'date') {
      return _dateView(c);
    }
    if (a == 'amount') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text('${doubleOrZero(b)}'),
      );
    }
    // if (a == 'name') {
    //   return Text('${doubleOrZero(_itemsSize(c))}');
    // }
    return Text('$b');
  }

  _itemsSize(c) {
    var getItems =
        compose([(x) => x.length, itOrEmptyArray, propertyOrNull('items')]);
    return getItems(c);
  }

  _getTimer(c) {
    var getTimer = propertyOr('timer', (p0) => '');
    var date = DateTime.tryParse(getTimer(c)) ?? DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(date);
  }

  _appBar(context) {
    return StockAppBar(
      title: "Expenses",
      showBack: true,
      backLink: '/expense/',
      showSearch: false,
      onSearch: (d) {
        setState(() {
          _query = d;
        });
        _refresh();
      },
      searchHint: 'Search expense...',
    );
  }

  _contextSales(context) {
    return [
      ContextMenu(
        name: 'Add',
        pressed: () => navigateTo('/expense/expenses/create'),
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    var height = 38.0;
    var smallView = SizedBox(
      height: height,
      child: tableLikeListRow([
        tableLikeListTextHeader('Date'),
        tableLikeListTextHeader('Item'),
        tableLikeListTextHeader('Amount ( TZS )'),
      ]),
    );
    var bigView = SizedBox(
      height: height,
      child: tableLikeListRow([
        tableLikeListTextHeader('Date'),
        tableLikeListTextHeader('Item'),
        tableLikeListTextHeader('Amount ( TZS )'),
        tableLikeListTextHeader('Category'),
      ]),
    );
    return isSmallScreen(context) ? smallView : bigView;
  }

  _fields() => isSmallScreen(context)
      ? ['date', 'name', 'amount']
      : ['date', 'name', 'amount', 'category'];

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => responsiveBody(
      menus: moduleMenus(),
      current: '/expense/',
      onBody: (d) => Scaffold(appBar: _appBar(context), body: _body()));

  _loadMore() {
    setState(() {
      _loading = true;
    });
    var getExp = _prepareGetExpenses(_query, size, true);
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
    var getExp = _prepareGetExpenses(_query, size, false);
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

  _prepareGetExpenses(String product, size, bool more) {
    return ifDoElse(
      (x) => x is List && x.isNotEmpty,
      (x) {
        var last = more ? x.last['timer'] : _defaultLast();
        return getExpenses(last, size);
      },
      (_) => getExpenses(_defaultLast(), size),
    );
  }

  Widget _dateView(c) {
    var textStyle = const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
        height: 2.0,
        overflow: TextOverflow.ellipsis);
    var mainTextStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis);
    var subText = timeago.format(DateTime.parse(c['timer']));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getTimer(c), style: mainTextStyle),
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
        onLoadMore: () async => _loadMore(),
        loading: _loading,
      ),
    );
  }

  _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _loadingView(_loading),
        tableContextMenu(_contextSales(context)),
        _tableHeader(),
        _salesList(),
      ],
    );
  }
}
