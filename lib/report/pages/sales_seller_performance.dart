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

class SellerPerformance extends PageBase {
  final OnBackPage onBackPage;

  const SellerPerformance({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'SellerPerformanceReport');

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
        const HorizontalLine()
      ],
    );
  }

  _tableHeader() {
    return const TableLikeListRow([
      LabelMedium(text: 'SELLER'),
      LabelMedium(text: 'QUANTITY'),
      LabelMedium(text: 'AMOUNT'),
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
}
