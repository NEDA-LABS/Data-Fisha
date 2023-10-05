import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';

class SellerPerformance extends StatefulWidget {
  final OnBackPage onBackPage;

  const SellerPerformance({
    Key? key,
    required this.onBackPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SellerPerformance> {
  var loading = false;
  String error = '';
  var dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  var dailySales = [];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/report/',
      sliverAppBar: _appBar(),
      staticChildren: [
        _rangePicker(),
        _showLoading(),
        _tableHeader(),
      ],
      totalDynamicChildren: dailySales.length,
      dynamicChildBuilder: _largerScreenChildBuilder,
      // onBody: (x) {
      //   return SingleChildScrollView(
      //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      //     child: Center(
      //       child: Container(
      //         constraints: BoxConstraints(maxWidth: maximumBodyWidth),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             _whatToShow(),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      // },
    );
  }

  // charts.Series<dynamic, String> _sales2Series(List sales) {
  //   return charts.Series<dynamic, String>(
  //     id: 'Sales',
  //     colorFn: (_, __) =>
  //         charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark),
  //     domainFn: (dynamic sales, _) => sales['date'],
  //     measureFn: (dynamic sales, _) => sales['amount'],
  //     data: dailySales,
  //   );
  // }

  _showLoading() => loading ? const LinearProgressIndicator() : Container();

  _fetchData() {
    setState(() {
      loading = true;
    });
    getSellerPerformance(dateRange).then((value) {
      dailySales = itOrEmptyArray(value);
    }).catchError((err) {
      error = '$err';
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  // _loading() {
  //   return const SizedBox(
  //     height: 100,
  //     child: Center(
  //       child: SizedBox(
  //         height: 30,
  //         width: 30,
  //         child: CircularProgressIndicator(),
  //       ),
  //     ),
  //   );
  // }

  // _retry() {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(error),
  //         OutlinedButton(
  //             onPressed: () => setState(() => _fetchData()),
  //             child: const Text('Retry'))
  //       ],
  //     ),
  //   );
  // }
  //
  // _chartAndTable() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       // Card(
  //       //   child: Container(
  //       //     height: 350,
  //       //     padding: const EdgeInsets.all(8),
  //       //     child: BarChart(
  //       //       [_sales2Series(dailySales)],
  //       //       animate: true,
  //       //     ),
  //       //   ),
  //       // ),
  //       // const SizedBox(height: 16),
  //       Card(
  //         child: Container(
  //           constraints: const BoxConstraints(maxHeight: 500),
  //           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  //           child: TableLikeList(
  //             onFuture: () async => dailySales,
  //             keys: _fields(),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          // onTap: () => showDialogOrModalSheet(
          //     purchaseDetails(context, _purchases[index]), context),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${dailySales[index]['id']}'),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TableLikeListTextDataCell(
                  '${formatNumber(dailySales[index]['quantity'])}'),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TableLikeListTextDataCell(
                  '${formatNumber(dailySales[index]['amount'])}'),
            ),
          ]),
        ),
        HorizontalLine()
      ],
    );
  }

  _tableHeader() {
    return const TableLikeListRow([
      TableLikeListTextHeaderCell('Seller'),
      TableLikeListTextHeaderCell('Quantity'),
      TableLikeListTextHeaderCell('Amount ( Tsh )'),
      // tableLikeListTextHeader('Total ( Tsh )'),
    ]);
  }

  // _fields() {
  //   return ['id', 'quantity', 'amount'];
  // }

  _rangePicker() {
    return ReportDateRange(
      onExport: (range) {
        var dateF = DateFormat('yyyy-MM-dd');
        var startD = dateF.format(range?.start ?? DateTime.now());
        var endD = dateF.format(range?.end ?? DateTime.now());
        var title = "Sales seller performance $startD -> $endD";
        showDialogOrModalSheet(
          dataExportOptions(
            onPdf: () {
              exportPDF(title, dailySales);
              Navigator.maybePop(context);
            },
            onCsv: () {
              exportToCsv(title, dailySales);
              Navigator.maybePop(context);
            },
          ),
          context,
        );
      },
      onRange: (range, period) {
        if (range != null) {
          setState(() {
            dateRange = range;
          });
          _fetchData();
        }
      },
      dateRange: dateRange,
    );
  }

  _appBar() {
    return SliverSmartStockAppBar(
      title: "Seller performance",
      showBack: true,
      onBack: widget.onBackPage,
      // backLink: '/report/',
      context: context,
    );
  }

// _whatToShow() {
//   var getView = ifDoElse(
//       (x) => x,
//       (_) => _loading(),
//       ifDoElse(
//           (_) => error.isNotEmpty, (_) => _retry(), (_) => _chartAndTable()));
//   return getView(loading);
// }
}
