import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/summary_report_card.dart';
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
      children: [
        _header(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: horizontalLine(),
        ),
        loading
            ? const SizedBox(
                height: 100,
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : error.isNotEmpty
                ? Padding(
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
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _reportTitle('Profit & Loss'),
                      _profitAndLoss(data),
                      _reportTitle('Cash sales'),
                      _sales(data),
                      _reportTitle('Invoice sales'),
                      _invoices(data),
                      _reportTitle('Expenditure'),
                      _expenditure(data),
                    ],
                  ),
        // _reports()
      ],
    );
  }

  _profitAndLoss(data) {
    Future getSales() async => data is Map ? doubleOrZero(data['profit']) : 0;
    Future getMargin() async => data is Map ? doubleOrZero(data['margin']) : 0;
    return Wrap(
      children: [
        DashboardSummaryReportCard(
          title: 'Gross profit',
          future: getSales,
          showRefresh: false,
        ),
        DashboardSummaryReportCard(
          title: 'Gross margin ( % )',
          future: getMargin,
          showRefresh: false,
        )
      ],
    );
  }

  _sales(data) {
    Future getSales() async =>
        data is Map ? doubleOrZero(data['sales_cash']) : 0;
    Future items() async => data is Map ? doubleOrZero(data['items_cash']) : 0;
    return Wrap(
      children: [
        DashboardSummaryReportCard(
          title: 'Sales',
          future: getSales,
          showRefresh: false,
        ),
        DashboardSummaryReportCard(
          title: 'Items',
          future: items,
          showRefresh: false,
        )
      ],
    );
  }

  _invoices(data) {
    Future getSales() async =>
        data is Map ? doubleOrZero(data['sales_invoice']) : 0;
    Future items() async =>
        data is Map ? doubleOrZero(data['items_invoice']) : 0;
    return Wrap(
      children: [
        DashboardSummaryReportCard(
          title: 'Invoices',
          future: getSales,
          showRefresh: false,
        ),
        DashboardSummaryReportCard(
          title: 'Items',
          future: items,
          showRefresh: false,
        )
      ],
    );
  }

  _expenditure(data) {
    Future getSales() async => data is Map
        ? (doubleOrZero(data['cogs_cash']) + doubleOrZero(data['cogs_invoice']))
        : 0;
    Future items() async => data is Map ? doubleOrZero(data['expense']) : 0;
    return Wrap(
      children: [
        DashboardSummaryReportCard(
          title: 'Cost of good sold',
          future: getSales,
          showRefresh: false,
        ),
        DashboardSummaryReportCard(
          title: 'Expenses',
          future: items,
          showRefresh: false,
        )
      ],
    );
  }

  _reportTitle(title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$title',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
