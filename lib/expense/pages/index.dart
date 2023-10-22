import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/number_card.dart';
import 'package:smartstock/expense/pages/ExpenseCreatePage.dart';
import 'package:smartstock/expense/pages/ExpensesPage.dart';
import 'package:smartstock/expense/services/index.dart';

class ExpenseIndexPage extends PageBase {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ExpenseIndexPage({
    Key? key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key, pageName: 'ExpenseIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseIndexPage> {
  bool loading = false;
  DateTime date = DateTime.now();
  var data = {};

  @override
  void initState() {
    _fetchSummary();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/expenses/',
      staticChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            loading ? const LinearProgressIndicator() : Container(),
            const SwitchToTitle(),
            SwitchToPageMenu(pages: _pagesMenu(context)),
            const WhiteSpacer(height: 16),
            const BodySmall(text: 'Summary'),
            const WhiteSpacer(height: 8),
            _getSummaryReportView(context),
          ],
        )
      ],
      sliverAppBar: SliverSmartStockAppBar(
          title: "Expenses", showBack: false, context: context),
    );
  }

  void _fetchSummary() {
    setState(() {
      loading = true;
    });
    getExpensesSummaryReport(date).then((value) {
      data = value;
    }).catchError((onError) {
      showInfoDialog(context, onError, title: 'Error');
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  _getIt(String p, data) => data is Map ? data[p] : null;

  _getSummaryReportView(BuildContext context) {
    var todayExpense = Expanded(
      flex: 1,
      child: NumberCard(
        "Today",
        doubleOrZero(_getIt('today', data)),
        null,
        onClick: () => widget.onChangePage(ExpenseExpensesPage(
          onBackPage: widget.onBackPage,
          onChangePage: widget.onChangePage,
        )),
      ),
    );
    var weekExpense = Expanded(
      flex: 1,
      child: NumberCard(
        "This week",
        doubleOrZero(_getIt('week', data)),
        null,
        onClick: () => widget.onChangePage(ExpenseExpensesPage(
          onBackPage: widget.onBackPage,
          onChangePage: widget.onChangePage,
        )),
      ),
    );
    var monthExpense = Expanded(
      flex: 1,
      child: NumberCard(
        "This month",
        doubleOrZero(_getIt('month', data)),
        null,
        onClick: () => widget.onChangePage(ExpenseExpensesPage(
          onBackPage: widget.onBackPage,
          onChangePage: widget.onChangePage,
        )),
      ),
    );
    var yearExpense = Expanded(
      flex: 1,
      child: NumberCard(
        "This year",
        doubleOrZero(_getIt('year', data)),
        null,
        onClick: () => widget.onChangePage(ExpenseExpensesPage(
          onBackPage: widget.onBackPage,
          onChangePage: widget.onChangePage,
        )),
      ),
    );
    var getView = ifDoElse(
      (context) => getIsSmallScreen(context),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [todayExpense, weekExpense],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [monthExpense, yearExpense],
          ),
        ],
      ),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              todayExpense,
              weekExpense,
              monthExpense,
              yearExpense,
            ],
          ),
        ],
      ),
    );
    return getView(context);
  }

  List<ModulePageMenu> _pagesMenu(BuildContext context) {
    return [
      ModulePageMenu(
        name: 'Create expense',
        link: '/expense/create',
        icon: Icons.receipt,
        roles: [],
        onClick: () => widget
            .onChangePage(ExpenseCreatePage(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'All expenses',
        link: '/expense',
        icon: Icons.receipt_long,
        roles: [],
        onClick: () => widget.onChangePage(
          ExpenseExpensesPage(
            onBackPage: widget.onBackPage,
            onChangePage: widget.onChangePage,
          ),
        ),
      ),
    ];
  }
}
