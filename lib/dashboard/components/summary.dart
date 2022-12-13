import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/numberCard.dart';
import 'package:smartstock/dashboard/components/past_expenses.dart';
import 'package:smartstock/dashboard/components/past_expenses_by_item.dart';
import 'package:smartstock/dashboard/components/past_sales.dart';
import 'package:smartstock/dashboard/components/past_sales_by_categories.dart';
import 'package:smartstock/dashboard/services/dashboard.dart';

class DashboardSummary extends StatefulWidget {
  const DashboardSummary({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardSummary> {
  bool loading = false;
  DateTime date = DateTime.now();
  var data = {};
  var error = '';

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [_header(), _lineView(), _loadingErrorOrMain()],
    );
  }

  _loadingErrorOrMain() {
    var getView = ifDoElse(
      (x) => x == true,
      (_) => _loadingView(),
      ifDoElse(
        (x) => x == false && error.isNotEmpty,
        (_) => _errorView(),
        (_) => _mainView(),
      ),
    );
    return getView(loading);
  }

  _withPaddingView(view) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: view,
    );
  }



  _getIt(String p, data) => data is Map ? data[p] : null;

  _mainView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: numberPercentageCard(
                  "Cash sales", doubleOrZero(_getIt('sales_cash', data)), null),
              flex: 1,
            ),
            Expanded(
              child: numberPercentageCard("Invoices",
                  doubleOrZero(_getIt('sales_invoice', data)), null),
              flex: 1,
            ),
            Expanded(
              child: numberPercentageCard(
                  "Expenses", doubleOrZero(_getIt('expense', data)), null),
              flex: 1,
            ),
            Expanded(
              child: numberPercentageCard(
                  "Gross profit",
                  doubleOrZero(_getIt('profit', data)),
                  doubleOrZero(_getIt('margin', data))),
              flex: 1,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 3, child: PastSalesOverview(date: date)),
            Expanded(flex: 1, child: PastSalesByCategory(date: date))
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 2, child: PastExpensesOverview(date: date)),
            Expanded(flex: 2, child: PastExpensesByItemOverview(date: date))
          ],
        )
      ],
    );
  }

  _lineView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: horizontalLine(),
    );
  }

  _loadingView() {
    return const SizedBox(
      height: 100,
      child: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _errorView() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error),
          OutlinedButton(
              onPressed: () => setState(() => _fetchData()),
              child: const Text('Retry'))
        ],
      ),
    );
  }

  _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              _getToday(date),
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          // outlineButton(title: "Date", onPressed: () {}),
          outlineActionButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
              ).then((value) {
                if (value != null) {
                  date = value;
                  _fetchData();
                }
              });
            },
            title: 'Change',
          ),
        ],
      ),
    );
  }

  String _getToday(DateTime date) {
    var dateFormat = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY);
    return dateFormat.format(date);
  }

  void _fetchData() {
    setState(() {
      loading = true;
      error = '';
    });
    prepareGetDashboardData(date).then((value) {
      setState(() {
        data = value;
      });
    }).catchError((onError) {
      setState(() {
        error = '$onError';
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
