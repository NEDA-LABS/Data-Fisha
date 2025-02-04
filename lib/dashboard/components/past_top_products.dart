import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/report/services/report.dart';

class PastTopProducts extends StatefulWidget {
  final DateTime date;

  const PastTopProducts({required this.date, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PastTopProducts> {
  var loading = false;
  String error = '';
  DateTimeRange? dateRange;
  var salesByProducts = [];

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
    getProductPerformance(dateRange ?? defaultRange).then((value) {
      salesByProducts = itOrEmptyArray(value);
      salesByProducts = salesByProducts.sublist(
          0, salesByProducts.length > 5 ? 5 : salesByProducts.length);
      // salesByCategory.sort((a, b) => a['amount'] - b['amount']);
      // salesByCategory = salesByCategory.reversed.toList();
      // totalAmount = salesByCategory.fold(
      //     0, (a, element) => doubleOrZero(a + element['amount'] ?? 0));
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
          BodyLarge(text: error),
          OutlinedButton(
              onPressed: () => setState(() => _fetchData()),
              child: const BodyLarge(text:'Retry'))
        ],
      ),
    );
  }

  _productsTable() {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: solidRadiusBoxDecoration(context),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 410, minHeight: 200),
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: BodyMedium(text: 'Top selling products'),
              ),
              const TableLikeListRow([
                TableLikeListHeaderCell('Name'),
                TableLikeListHeaderCell('Qty'),
                TableLikeListHeaderCell('Amount'),
                TableLikeListHeaderCell('Profit'),
                TableLikeListHeaderCell('Margin'),
              ]),
              HorizontalLine(),
              Expanded(
                child: TableLikeList(
                  onFuture: () async => salesByProducts,
                  onCell: (key, p1, p2) {
                    var style = const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1C1C1C));
                    if (key == 'amount') {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4.0),
                        child: BodyMedium(
                            text: '${compactNumber(doubleOrZero(p1))}'),
                      );
                    }
                    if (key == 'profit') {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4.0),
                        child: BodyMedium(
                            text: '${compactNumber(doubleOrZero(p1))}'),
                      );
                    }
                    if (key == 'margin') {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4.0),
                        child: BodyMedium(text: '${doubleOrZero(p1)}%'),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 4, 4.0),
                      child: BodyMedium(text: '$p1'),
                    );
                  },
                  keys: const [
                    'product',
                    'quantity',
                    'amount',
                    'profit',
                    'margin'
                  ],
                ),
              )
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
          (_) => error.isNotEmpty,
          (_) => _retry(),
          (_) => _productsTable(),
        ));
    return getView(loading);
  }
}
