import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/expense/components/expense_details.dart';
import 'package:smartstock/expense/pages/ExpenseCreatePage.dart';

import '../services/expenses.dart';

class ExpenseExpensesPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const ExpenseExpensesPage({
    Key? key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(key: key, pageName: 'ExpenseExpensesPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseExpensesPage> {
  bool _loading = false;
  int size = 20;
  List _expenses = [];

  _contextSales(context) {
    return [
      ContextMenu(
        name: 'Add expense',
        pressed: () => widget.onChangePage(
          ExpenseCreatePage(onBackPage: widget.onBackPage),
        ),
      ),
      ContextMenu(name: 'Reload expenses', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    var height = 38.0;
    return SizedBox(
      height: height,
      child: const TableLikeListRow([
        TableLikeListHeaderCell('Item'),
        TableLikeListHeaderCell('Category'),
        TableLikeListHeaderCell('Amount ( TZS )'),
        TableLikeListHeaderCell('Date'),
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
      current: '/expense/',
      backgroundColor: Theme.of(context).colorScheme.surface,
      sliverAppBar: SliverSmartStockAppBar(
        title: "Expenses",
        showBack: true,
        onBack: widget.onBackPage,
        context: context,
      ),
      staticChildren: [
        _loadingView(_loading),
        getIsSmallScreen(context)
            ? Container()
            : tableContextMenu(_contextSales(context)),
        getIsSmallScreen(context) ? Container() : _tableHeader(),
      ],
      totalDynamicChildren: _expenses.length,
      dynamicChildBuilder:
          getIsSmallScreen(context) ? _smallScreen : _largerScreen,
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
        InkWell(
          onTap: ()=>_showDetails(index),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${_expenses[index]['name']}'),
            TableLikeListTextDataCell('${_expenses[index]['category']}'),
            TableLikeListTextDataCell(
                '${formatNumber(_expenses[index]['amount'])}'),
            TableLikeListTextDataCell('${_expenses[index]['date']}'),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  Widget _smallScreen(context, index) {
    return InkWell(
      onTap: ()=>_showDetails(index),
      child: Column(
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
          ),
          const SizedBox(height: 5),
          const HorizontalLine(),
        ],
      ),
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
                widget.onChangePage(
                  ExpenseCreatePage(onBackPage: widget.onBackPage),
                );
              },
            ),
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
      context,
    );
  }

  void _showDetails(index){
    showDialogOrModalSheet(
      ExpenseDetail(
        item: _expenses[index],
        onChangePage: widget.onChangePage,
        onBackPage: widget.onBackPage,
        onRefresh: _refresh,
      ),
      context,
    );
  }
}
