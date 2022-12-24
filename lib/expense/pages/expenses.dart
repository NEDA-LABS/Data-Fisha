import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_expense_content.dart';

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

  _contextSales(context) {
    return [
      ContextMenu(name: 'Add', pressed: _addExpenseView),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    var height = 38.0;
    return SizedBox(
      height: height,
      child: const TableLikeListRow([
        TableLikeListTextHeaderCell('Item'),
        TableLikeListTextHeaderCell('Category'),
        TableLikeListTextHeaderCell('Amount ( TZS )'),
        TableLikeListTextHeaderCell('Date'),
      ]),
    );
  }

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
      sliverAppBar:
          StockAppBar(title: "Expenses", showBack: false, context: context),
      staticChildren: [
        _loadingView(_loading),
        isSmallScreen(context)
            ? Container()
            : tableContextMenu(_contextSales(context)),
        isSmallScreen(context) ? Container() : _tableHeader(),
      ],
      totalDynamicChildren: _expenses.length,
      dynamicChildBuilder:
          isSmallScreen(context) ? _smallScreen : _largerScreen,
      loading: _loading,
      onLoadMore: () async => _loadMore(),
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more_outlined),
      ),
    );
  }

  Widget _largerScreen(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableLikeListRow([
          TableLikeListTextDataCell('${_expenses[index]['name']}'),
          TableLikeListTextDataCell('${_expenses[index]['category']}'),
          TableLikeListTextDataCell(
              '${formatNumber(_expenses[index]['amount'])}'),
          TableLikeListTextDataCell('${_expenses[index]['date']}'),
        ]),
        horizontalLine()
      ],
    );
  }

  Widget _smallScreen(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableLikeListTextDataCell('${_expenses[index]['name']}'),
              TableLikeListTextDataCell(
                  '${formatNumber(_expenses[index]['amount'])}'),
            ],
          ),
          subtitle: Text('${_expenses[index]['date']}'),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text('${_expenses[index]['date']}'),
          //         Text(
          //             'total ${compactNumber('${_purchases[index]['amount']}')}'),
          //       ],
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 4.0),
          //       child: Text(
          //         '${_purchases[index]['supplier']}',
          //         style: const TextStyle(fontSize: 13),
          //       ),
          //     ),
          //   ],
          // ),
        ),
        const SizedBox(height: 5),
        horizontalLine(),
      ],
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
                title: const Text('Add expense'),
                onTap: () {
                  Navigator.of(context)
                      .maybePop()
                      .whenComplete(() => _addExpenseView());
                },
              ),
              horizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload expenses'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _refresh();
                },
              ),
            ],
          ),
        ),
        context);
  }

  _addExpenseView() {
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
  }
}
