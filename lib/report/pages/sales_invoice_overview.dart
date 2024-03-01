import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/Histogram.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/HistogramData.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';

class OverviewInvoiceSales extends PageBase {
  final OnBackPage onBackPage;

  const OverviewInvoiceSales({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'OverviewInvoiceSales');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<OverviewInvoiceSales> {
  Map _shop = {};
  var loading = false;
  String error = '';
  var dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  var dailySales = [];
  String period = 'day';

  @override
  void initState() {
    getActiveShop().then((value) {
      _updateState(() {
        _shop = value;
      });
    }).catchError((e) {});
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
      dynamicChildBuilder: _getDynamicBuilder,
    );
  }

  Widget _getDynamicBuilder(context, index) {
    if (getIsSmallScreen(context)) {
      return _smallScreenChildBuilder(context, index);
    } else {
      return _largerScreenChildBuilder(context, index);
    }
  }

  Widget _largerScreenChildBuilder(context, index) {
    var amountPaid = doubleOrZero(dailySales[index]['amount_paid']);
    var cogs = doubleOrZero(dailySales[index]['cogs']);
    var amount = doubleOrZero(dailySales[index]['amount']);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          child: TableLikeListRow([
            TableLikeListTextDataCell('${dailySales[index]['date']}'),
            TableLikeListTextDataCell('${formatNumber(amount)}'),
            TableLikeListTextDataCell('${formatNumber(amountPaid)}'),
            TableLikeListTextDataCell('${formatNumber(cogs)}'),
            TableLikeListTextDataCell('${formatNumber(amountPaid - cogs)}'),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  Widget _smallScreenChildBuilder(context, index) {
    var amount = doubleOrZero(dailySales[index]['amount']);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => _showMoreDetails(dailySales[index]),
          title: LabelLarge(text: '${dailySales[index]['date']}'),
          // isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const WhiteSpacer(height: 8),
              BodyLarge(
                  text:
                      '${_shop['settings']?['currency'] ?? ''} ${formatNumber(amount)}'),
              // const WhiteSpacer(height: 4),
              // const BodyMedium(text:'Click for more details'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelMedium(
                  text: 'View', color: Theme.of(context).colorScheme.primary),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
        ),
        const HorizontalLine()
      ],
    );
  }

  _showMoreDetails(Map item) {
    var currency = _shop['settings']?['currency'] ?? '';
    var amountPaid = doubleOrZero(item['amount_paid']);
    var cogs = doubleOrZero(item['cogs']);
    var amount = doubleOrZero(item['amount']);
    showDialogOrModalSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const LabelMedium(text: 'DATE'),
                  BodyLarge(text: item['date']),
                  const WhiteSpacer(height: 16),
                  const LabelMedium(text: 'AMOUNT'),
                  BodyLarge(text: '$currency ${formatNumber(amount)}'),
                  const WhiteSpacer(height: 16),
                  const LabelMedium(text: 'AMOUNT PAID'),
                  BodyLarge(text: '$currency ${formatNumber(amountPaid)}'),
                  const WhiteSpacer(height: 16),
                  const LabelMedium(text: 'COGS'),
                  BodyLarge(
                      text: '$currency ( ${formatNumber(item['cogs'])} )'),
                  const WhiteSpacer(height: 16),
                  // const LabelMedium(text: 'EXPENSE'),
                  // BodyLarge(
                  //     text: '$currency ( ${formatNumber(item['expense'])} )'),
                  // const WhiteSpacer(height: 16),
                  const LabelMedium(text: 'PROFIT'),
                  BodyLarge(
                      text: '$currency ${formatNumber(amountPaid-cogs)}'),
                  // const WhiteSpacer(height: 8),
                ],
              ),
            ),
            const HorizontalLine(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CancelProcessButtonsRow(
                cancelText: 'Close',
                onCancel: () {
                  Navigator.of(context).maybePop();
                },
              ),
            )
          ],
        ),
        context);
  }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _tableHeader() {
    if (getIsSmallScreen(context)) {
      return Container();
    }
    return TableLikeListRow([
      const LabelMedium(text: 'DATE'),
      LabelMedium(text: 'AMOUNT\n( ${_shop['settings']?['currency'] ?? ''} )'),
      LabelMedium(
          text: 'AMOUNT PAID\n( ${_shop['settings']?['currency'] ?? ''} )'),
      LabelMedium(text: 'COGS\n( ${_shop['settings']?['currency'] ?? ''} )'),
      LabelMedium(text: 'PROFIT\n( ${_shop['settings']?['currency'] ?? ''} )'),
    ]);
  }

  _showLoading() => loading ? const LinearProgressIndicator() : Container();

  _fetchData() {
    setState(() {
      loading = true;
    });
    getInvoiceSalesOverview(dateRange, period).then((value) {
      dailySales = itOrEmptyArray(value);
    }).catchError((err) {
      error = '$err';
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  _rangePicker() {
    return ReportDateRange(
      onExport: (range) {
        var dateF = DateFormat('yyyy-MM-dd');
        var startD = dateF.format(range?.start ?? DateTime.now());
        var endD = dateF.format(range?.end ?? DateTime.now());
        var title = "Invoice sales $startD -> $endD";
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
    return SliverSmartStockAppBar(
      title: "Invoice sales overview",
      showBack: true,
      onBack: widget.onBackPage,
      // backLink: '/report/',
      context: context,
    );
  }
}
