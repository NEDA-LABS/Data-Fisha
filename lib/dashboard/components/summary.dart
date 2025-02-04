import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/dashboard/components/number_card.dart';
import 'package:smartstock/dashboard/components/past_expenses.dart';
import 'package:smartstock/dashboard/components/past_expenses_by_item.dart';
import 'package:smartstock/dashboard/components/past_sales.dart';
import 'package:smartstock/dashboard/components/past_sales_by_categories.dart';
import 'package:smartstock/dashboard/services/dashboard.dart';

class DashboardSummary extends StatefulWidget {
  const DashboardSummary({super.key});

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
      children: [_header(), _loadingErrorOrMain()],
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

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _getIt(String p, data) => data is Map ? data[p] : null;

  _mainView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _getTotalSalesView(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: BodyMedium(
            text: 'Past 7 days revenue.',
          ),
        ),
        _getHistorySales(),
        const SizedBox(height: 8),
      ],
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
          BodyLarge(text: error),
          OutlinedButton(
              onPressed: () => _updateState(() => _fetchData()),
              child: const BodyLarge(text: 'Retry'))
        ],
      ),
    );
  }

  _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 6, bottom: 16),
      child: GestureDetector(
        onTap: _showDatePicker,
        child: Row(
          children: [
            BodyMedium(
              text: _getToday(date)
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              // color: Color(0x33000000),
            ),
          ],
        ),
      ),
    );
  }

  String _getToday(DateTime date) {
    var dateFormat = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY);
    return dateFormat.format(date);
  }

  void _fetchData() {
    // _updateState(() {
    //   loading = true;
    //   error = '';
    // });
    // prepareGetDashboardData(date).then((value) {
    //   _updateState(() {
    //     data = value;
    //   });
    // }).catchError((onError) {
    //   _updateState(() {
    //     error = '$onError';
    //   });
    // }).whenComplete(() {
    //   if (mounted) {
    //     _updateState(() {
    //       loading = false;
    //     });
    //   }
    // });
  }

  _getTotalSalesView() {
    var totalCash = Expanded(
      flex: 1,
      child: NumberCard(
          "Total cash",
          doubleOrZero(_getIt('sales_cash', data)) +
              doubleOrZero(_getIt('paid_invoice', data)),
          null),
    );
    var cashSale = Expanded(
      flex: 1,
      child: NumberCard(
          "Cash sales", doubleOrZero(_getIt('sales_cash', data)), null),
    );
    var invoiceSale = Expanded(
      flex: 1,
      child: NumberCard(
          "Invoice sales", doubleOrZero(_getIt('sales_invoice', data)), null),
    );
    var paidInvoices = Expanded(
      flex: 1,
      child: NumberCard(
          "Paid invoices", doubleOrZero(_getIt('paid_invoice', data)), null),
    );
    var expenses = Expanded(
      flex: 1,
      child:
          NumberCard("Expenses", doubleOrZero(_getIt('expense', data)), null),
    );
    var grossProfit = Expanded(
      flex: 1,
      child: NumberCard(
          "Gross profit", doubleOrZero(_getIt('profit', data)), null),
    );
    var getView = ifDoElse(
      (context) => getIsSmallScreen(context),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [totalCash, grossProfit],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [cashSale, invoiceSale],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [paidInvoices, expenses],
          )
        ],
      ),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [cashSale, paidInvoices, totalCash],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [invoiceSale, expenses, grossProfit],
          ),
        ],
      ),
    );
    return getView(context);
  }

  _getHistorySales() {
    var getView = ifDoElse(
        (context) => getIsSmallScreen(context),
        (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PastSalesOverview(date: date),
                PastSalesByCategory(date: date)
              ],
            ),
        (context) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expanded(flex: 2, child: PastSalesOverview(date: date)),
                Expanded(flex: 1, child: PastSalesByCategory(date: date))
              ],
            ));
    return getView(context);
  }

  _getHistoryExpenses() {
    var getView = ifDoElse(
        (context) => getIsSmallScreen(context),
        (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PastExpensesOverview(date: date),
                PastExpensesByItemOverview(date: date)
              ],
            ),
        (context) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(flex: 2, child: PastExpensesOverview(date: date)),
                Expanded(flex: 1, child: PastExpensesByItemOverview(date: date))
              ],
            ));
    return getView(context);
  }

  void _showDatePicker() {
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
  }
}
