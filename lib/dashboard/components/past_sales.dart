import 'package:bfast/util.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/components/time_series_chart.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/services/report.dart';

class PastSalesOverview extends StatefulWidget {
  final DateTime date;

  const PastSalesOverview({required this.date, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PastSalesOverview> {
  var loading = false;
  String error = '';
  DateTimeRange? dateRange;
  String period = 'day';
  var dailySales = [];
  var dailyInvoices = [];

  @override
  void initState() {
    dateRange = DateTimeRange(
      start: widget.date.subtract(const Duration(days: 7)),
      end: widget.date,
    );
    _fetchData();
    super.initState();
  }

  @override
  Widget build(context) {
    return _whatToShow();
  }

  charts.Series<dynamic, DateTime> _sales2Series() {
    return charts.Series<dynamic, DateTime>(
      id: 'Cash',
      // colorFn: (_, __) =>
      //     charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark),
      domainFn: (dynamic sales, _) => DateTime.parse(sales['date']),
      measureFn: (dynamic sales, _) => sales['amount'],
      data: dailySales,
      // displayName: 'Past seven days from ${dateRange?.end?.toLocal()}',
    );
  }

  charts.Series<dynamic, DateTime> _invoiceSeries() {
    return charts.Series<dynamic, DateTime>(
      id: 'Invoices',
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark),
      domainFn: (dynamic sales, _) => DateTime.parse(sales['date']),
      measureFn: (dynamic sales, _) => sales['amount'],
      data: dailyInvoices,
      // displayName: 'Past seven days from ${dateRange?.end?.toLocal()}',
    );
  }

  _fetchData() {
    setState(() {
      loading = true;
    });
    var defaultRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    getCashSalesOverview(dateRange ?? defaultRange, period).then((value) {
      dailySales = itOrEmptyArray(value);
      return getInvoiceSalesOverview(dateRange ?? defaultRange, period);
    }).then((value) {
      dailyInvoices = itOrEmptyArray(value);
    }).catchError((err) {
      error = '$err';
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  _loading() {
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

  _retry() {
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

  _chartAndTable() {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: solidRadiusBoxDecoration(),
      child: Container(
        height: getIsSmallScreen(context)
            ? chartCardMobileHeight
            : chartCardDesktopHeight,
        padding: const EdgeInsets.all(8),
        child: TimeSeriesChart(
          [_sales2Series(), _invoiceSeries()],
          animate: false,
        ),
      ),
    );
  }

  _whatToShow() {
    var getView = ifDoElse(
        (x) => x,
        (_) => _loading(),
        ifDoElse(
            (_) => error.isNotEmpty, (_) => _retry(), (_) => _chartAndTable()));
    return getView(loading);
  }
}
