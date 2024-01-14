import 'package:flutter/material.dart';
import 'package:smartstock/core/components/bar_chart.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/report/services/report.dart';

class PastExpensesOverview extends StatefulWidget {
  final DateTime date;

  const PastExpensesOverview({required this.date, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PastExpensesOverview> {
  var loading = false;
  String error = '';
  DateTimeRange? dateRange;
  String period = 'day';
  var dailyExpenses = [];

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

  Map<dynamic, String> _sales2Series() {
    return {};
    // return charts.Series<dynamic, String>(
    //   id: 'Past 7 days expenses',
    //   colorFn: (_, __) =>
    //       charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark),
    // domainFn: (dynamic sales, _) => sales['date'],
    // measureFn: (dynamic sales, _) => sales['total'],
    // data: dailyExpenses,
    // displayName: 'Past seven days from ${dateRange?.end?.toLocal()}',
    // );
  }

  _fetchData() {
    setState(() {
      loading = true;
    });
    var defaultRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    getExpensesOverview(dateRange ?? defaultRange, period).then((value) {
      dailyExpenses = itOrEmptyArray(value);
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
      decoration: solidRadiusBoxDecoration(context),
      child: Container(
        height: getIsSmallScreen(context)
            ? chartCardMobileHeight
            : chartCardDesktopHeight,
        padding: const EdgeInsets.all(8),
        child: BarChart([_sales2Series()], animate: false),
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
