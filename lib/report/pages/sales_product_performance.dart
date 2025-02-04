import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';

class ProductPerformance extends PageBase {
  final OnBackPage onBackPage;

  const ProductPerformance({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'ProductsPerformanceReport');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductPerformance> {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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

  _fetchData() {
    setState(() {
      loading = true;
    });
    getProductPerformance(dateRange).then((value) {
      dailySales = itOrEmptyArray(value);
    }).catchError((err) {
      error = '$err';
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  _showLoading() => loading ? const LinearProgressIndicator() : Container();

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          // onTap: () => showDialogOrModalSheet(
          //     purchaseDetails(context, _purchases[index]), context),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${dailySales[index]['product']}'),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  TableLikeListTextDataCell('${dailySales[index]['margin']}%'),
            ),
          ]),
        ),
        HorizontalLine()
      ],
    );
  }

  _tableHeader() {
    return const TableLikeListRow([
      LabelMedium(text: 'PRODUCT'),
      LabelMedium(text: 'QUANTITY'),
      LabelMedium(text: 'AMOUNT'),
      LabelMedium(text: 'MARGIN ( % )'),
    ]);
  }

  // _fields() {
  //   return ['id', 'quantity', 'amount', 'margin'];
  // }

  _rangePicker() {
    return ReportDateRange(
      onExport: (range) {
        var dateF = DateFormat('yyyy-MM-dd');
        var startD = dateF.format(range?.start ?? DateTime.now());
        var endD = dateF.format(range?.end ?? DateTime.now());
        var title = "Sales product performance $startD -> $endD";
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
      title: "Product performance",
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
