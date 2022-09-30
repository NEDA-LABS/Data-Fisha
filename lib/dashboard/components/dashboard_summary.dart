import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/summary_report_card.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/services/api_dashboard.dart';
import 'package:smartstock/dashboard/services/dashboard.dart';

class DashboardSummary extends StatefulWidget {
  const DashboardSummary({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardSummary> {
  bool loading = false;

  // String stringDate = '';
  DateTime date = DateTime.now();

  @override
  void initState() {
    // stringDate = _getToday(DateTime.now());
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
        _reports()
      ],
    );
  }

  _reports() {
    return FutureBuilder(
      // initialData: const {},
      future: prepareGetDashboardData(date),
      builder: (context, snapshot) {
        // print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _reportTitle('Profit & Loss'),
            _profitAndLoss(snapshot.data),
            _reportTitle('Cash sales'),
            _sales(snapshot.data),
            _reportTitle('Invoice sales'),
            _invoices(snapshot.data),
            _reportTitle('Expenditure'),
            _expenditure(snapshot.data),
          ],
        );
      },
    );
  }

  _profitAndLoss(data) {
    Future getSales() async => data is Map ? data['profit'] : 0;
    Future getMargin() async => data is Map ? data['margin'] : 0;
    return Wrap(
      children: [
        DashboardSummaryReportCard(
          title: 'Gross profit',
          future: getSales,
          showRefresh: false,
        ),
        DashboardSummaryReportCard(
          title: 'Gross margin',
          future: getMargin,
          showRefresh: false,
        )
      ],
    );
  }

  _sales(data) {
    Future getSales() async => data is Map ? data['sales_cash'] : 0;
    Future items() async => data is Map ? data['items_cash'] : 0;
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
    Future getSales() async => data is Map ? data['sales_invoice'] : 0;
    Future items() async => data is Map ? data['items_invoice'] : 0;
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
        ? doubleOrZero(data['cogs_cash']) + doubleOrZero(data['cogs_invoice'])
        : 0;
    Future items() async => data is Map ? data['expense'] : 0;
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
                  fontSize: 18),
            ),
          ),
          // outlineButton(title: "Date", onPressed: () {}),
          outlineButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime.now(),
                ).then((value) {
                  value != null
                      ? setState(() {
                          date = value;
                        })
                      : null;
                });
              },
              title: 'Change'),
        ],
      ),
    );
  }

  String _getToday(DateTime date) {
    var dateFormat = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
    return dateFormat.format(date);
  }
}
