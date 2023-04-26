import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/Histogram.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/HistogramData.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';

class OverviewCashSales extends StatefulWidget {
  const OverviewCashSales({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<OverviewCashSales> {
  var loading = false;
  String error = '';
  var dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  String period = 'day';
  List dailySales = [];

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
      menus: getAppModuleMenus(context),
      sliverAppBar: _appBar(),
      staticChildren: [
        _rangePicker(),
        _showLoading(),
        dailySales.isNotEmpty
            ? Histogram(
                height: 200,
                data: dailySales.map((e) {
                  return HistogramData(
                      x: e['date'], y: '${e['amount']}', name: e['date']);
                }).toList())
            : Container(),
        const SizedBox(height: 16),
        _tableHeader(),
      ],
      totalDynamicChildren: dailySales.length,
      dynamicChildBuilder: getIsSmallScreen(context)
          ? _smallScreenChildBuilder
          : _largerScreenChildBuilder,
    );
  }

  _fetchData() {
    setState(() {
      loading = true;
    });
    getCashSalesOverview(dateRange, period).then((value) {
      dailySales = itOrEmptyArray(value);
    }).catchError((err) {
      error = '$err';
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  _tableHeader() {
    if (getIsSmallScreen(context)) {
      return const TableLikeListRow([
        TableLikeListTextHeaderCell('Date'),
        TableLikeListTextHeaderCell('Total'),
      ]);
    }
    return const TableLikeListRow([
      TableLikeListTextHeaderCell('Date'),
      TableLikeListTextHeaderCell('Retail'),
      TableLikeListTextHeaderCell('Wholesale'),
      TableLikeListTextHeaderCell('Total'),
    ]);
  }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          // onTap: () => showDialogOrModalSheet(
          //     purchaseDetails(context, _purchases[index]), context),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${dailySales[index]['date']}'),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TableLikeListTextDataCell(
                  '${formatNumber(dailySales[index]['amount_retail'])}'),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TableLikeListTextDataCell(
                  '${formatNumber(dailySales[index]['amount_whole'])}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableLikeListTextDataCell(
                  '${formatNumber(dailySales[index]['amount'])}'),
            ),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          child: TableLikeListRow([
            TableLikeListTextDataCell('${dailySales[index]['date']}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableLikeListTextDataCell(
                  '${formatNumber(dailySales[index]['amount'])}'),
            ),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  _rangePicker() {
    return ReportDateRange(
      onExport: (range) {
        var dateF = DateFormat('yyyy-MM-dd');
        var startD = dateF.format(range?.start ?? DateTime.now());
        var endD = dateF.format(range?.end ?? DateTime.now());
        showDialogOrModalSheet(
          dataExportOptions(onPdf: () {
            exportPDF("Cash sales $startD -> $endD", dailySales);
            Navigator.maybePop(context);
          }, onCsv: () {
            exportToCsv("Cash sales $startD -> $endD", dailySales);
            Navigator.maybePop(context);
          }, onExcel: () {
            exportToExcel("Cash sales $startD -> $endD", dailySales);
            Navigator.maybePop(context);
          }),
          context,
        );
      },
      onRange: (range, p) {
        if (range != null) {
          // setState(() {
          dateRange = range;
          period = p ?? 'day';
          // });
          _fetchData();
        }
      },
      dateRange: dateRange,
    );
  }

  _appBar() {
    return getSliverSmartStockAppBar(
      title: "Cash sales overview",
      showBack: true,
      // backLink: '/report/',
      onBack: () {
        Navigator.of(context).canPop()
            ? Navigator.of(context).pop()
            : Navigator.of(context).pushNamed('/');
      },
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

  _showLoading() => loading ? const LinearProgressIndicator() : Container();
}
