import 'package:bfast/util.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bar_chart.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';

class OverviewInvoiceSales extends StatefulWidget {
  const OverviewInvoiceSales({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<OverviewInvoiceSales> {
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
    _fetchData();
    super.initState();
  }

  @override
  Widget build(context) {
    return responsiveBody(
      office: 'Menu',
      current: '/report/',
      menus: moduleMenus(),
      onBody: (x) {
        return Scaffold(
          appBar: _appBar(),
          drawer: x,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maximumBodyWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _rangePicker(),
                    _whatToShow(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomBar(3, moduleMenus(), context),
        );
      },
    );
  }

  charts.Series<dynamic, String> _sales2Series(List sales) {
    return charts.Series<dynamic, String>(
      id: 'Sales',
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark),
      domainFn: (dynamic sales, _) => sales['date'],
      measureFn: (dynamic sales, _) => sales['amount'],
      data: dailySales,
    );
  }

  _fetchData() {
    setState(() {
      loading = true;
    });
    getInvoiceSalesOverview(dateRange,period).then((value) {
      dailySales = itOrEmptyArray(value);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Container(
            height: isSmallScreen(context)
                ? chartCardMobileHeight
                : chartCardDesktopHeight,
            padding: const EdgeInsets.all(8),
            child: BarChart(
              [_sales2Series(dailySales)],
              animate: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _tableHeader(),
        Card(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: TableLikeList(
              onFuture: () async => dailySales,
              keys: _fields(),
            ),
          ),
        )
      ],
    );
  }

  _tableHeader() {
    return tableLikeListRow([
      tableLikeListTextHeader('Date'),
      // tableLikeListTextHeader('Retail ( Tsh )'),
      // tableLikeListTextHeader('Wholesale ( Tsh )'),
      tableLikeListTextHeader('Total ( Tsh )'),
    ]);
  }

  _fields() {
    return ['date', 'amount'];
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
      onRange: (range,p) {
        if (range != null) {
          // setState(() {
            dateRange = range;
            period = p??'day';
          // });
          _fetchData();
        }
      },
      dateRange: dateRange,
    );
  }

  _appBar() {
    return StockAppBar(
      title: "Invoice sales overview",
      showBack: false,
      backLink: '/report/',
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
