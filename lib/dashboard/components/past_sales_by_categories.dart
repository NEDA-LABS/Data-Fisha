import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/report/services/report.dart';

class PastSalesByCategory extends StatefulWidget {
  final DateTime date;

  const PastSalesByCategory({required this.date, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PastSalesByCategory> {
  var loading = false;
  String error = '';
  DateTimeRange? dateRange;
  var salesByCategory = [];
  dynamic totalAmount = 0.0;

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
  Widget build(context) => _whatToShow();

  _fetchData() {
    setState(() {
      loading = true;
    });
    var defaultRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    getCategoryPerformance(dateRange ?? defaultRange).then((value) {
      salesByCategory = itOrEmptyArray(value);
      salesByCategory.sort((a, b) =>
          int.tryParse('${a['amount'] - b['amount']}'.split('.')[0]) ?? 0);
      salesByCategory = salesByCategory.reversed
          .toList()
          .sublist(0, salesByCategory.length > 5 ? 5 : salesByCategory.length);
      for (var element in salesByCategory) {
        totalAmount += doubleOrZero(element['amount']);
      }
    }).catchError((err) {
      error = '$err';
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
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
          BodyLarge(text: error),
          OutlinedButton(
              onPressed: () => setState(() => _fetchData()),
              child: const BodyLarge(text: 'Retry'))
        ],
      ),
    );
  }

  _chartAndTable() {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: solidRadiusBoxDecoration(context),
      child: Container(
        // height: chartCardDesktopHeight,
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BodyMedium(text: 'Sales by categories'),
              const SizedBox(height: 24),
              ...salesByCategory.map((e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LabelLarge(text: '${e['id'] ?? ''}'),
                          LabelLarge(
                              text: '${compactNumber(e['amount'] ?? 0)}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: _getProgValue(e['amount']),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ))
            ],
          ),
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

  _getProgValue(amount) {
    return doubleOrZero(amount) / totalAmount;
  }
}
