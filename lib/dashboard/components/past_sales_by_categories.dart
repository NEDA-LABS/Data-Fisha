import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/services/report.dart';

class PastSalesByCategory extends StatefulWidget {
  final DateTime date;

  const PastSalesByCategory({required this.date, Key? key}) : super(key: key);

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
      salesByCategory = salesByCategory.reversed.toList();
      for (var element in salesByCategory) {
        totalAmount += doubleOrZero(element['amount']);
      }
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
        height: isSmallScreen(context)
            ? chartCardMobileHeight
            : chartCardDesktopHeight,
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sales by categories',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              Expanded(
                child: ListView(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    ...salesByCategory.map((e) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${e['id'] ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      color: Color(0xFF1C1C1C)),
                                ),
                                Text(
                                  '${compactNumber(e['amount'] ?? 0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xFF1C1C1C)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                                value: _getProgValue(e['amount']),
                                backgroundColor: const Color(0x370049a9)),
                            const SizedBox(height: 16),
                          ],
                        ))
                  ],
                ),
              ),
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
