import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/services/util.dart';
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

  _numberPercentageCard(String? title, value, percentage) {
    var formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 3,
      symbol:
          '', // if you want to add currency symbol then pass that in this else leave it empty.
    ).format(value ?? 0);
    return SizedBox(
      height: 112,
      child: Card(
        elevation: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 0, 8),
              child: Text(
                "$title",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1C1C1C)),
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 26, 24),
                  child: Text(
                    formattedNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xFF1C1C1C)),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                  child: Text(
                    percentage == null
                        ? ''
                        : percentage > 0
                            ? "+$percentage%"
                            : "$percentage%",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF1C1C1C)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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
              child: _numberPercentageCard(
                  "Cash sales", doubleOrZero(_getIt('sales_cash', data)), null),
              flex: 1,
            ),
            Expanded(
              child: _numberPercentageCard("Invoices",
                  doubleOrZero(_getIt('sales_invoice', data)), null),
              flex: 1,
            ),
            Expanded(
              child: _numberPercentageCard(
                  "Expenses", doubleOrZero(_getIt('expense', data)), null),
              flex: 1,
            ),
            Expanded(
              child: _numberPercentageCard(
                  "Gross profit",
                  doubleOrZero(_getIt('profit', data)),
                  doubleOrZero(_getIt('margin', data))),
              flex: 1,
            ),
          ],
        ),
        // _reportTitle('Profit & Loss'),
        // _profitAndLoss(data),
        // _reportTitle('Cash sales'),
        // _sales(data),
        // _reportTitle('Invoice sales'),
        // _invoices(data),
        // _reportTitle('Expenditure'),
        // _expenditure(data),
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
