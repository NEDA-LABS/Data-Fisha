import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';
import 'package:smartstock/sales/components/sale_cash_details.dart';

class SalesTrackingPage extends PageBase {
  final OnBackPage onBackPage;

  const SalesTrackingPage({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'SalesCashTrackingPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesTrackingPage> {
  bool _loading = false;
  int size = 20;
  var dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 1)),
    end: DateTime.now(),
  );
  List _sales = [];

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      current: '/report/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        _loadingView(_loading),
        _rangePicker(),
        _tableHeader(),
      ],
      dynamicChildBuilder: (context, index) {
        return _tableRow(_sales[index]);
      },
      totalDynamicChildren: _sales.length,
    );
  }

  _tableRow(item) {
    Widget keyToView(k) => _onCell(k, item[k] ?? '', item);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 48),
          child: InkWell(
            onTap: () => _onItemPressed(item),
            child: TableLikeListRow(_fields().map<Widget>(keyToView).toList()),
          ),
        ),
        const HorizontalLine()
      ],
    );
  }

  _onItemPressed(item) {
    showDialogOrModalSheet(
        CashSaleDetail(sale: item, pageContext: context), context);
  }

  Widget _onCell(key, item, items) {
    if (key == 'date') {
      return _dateView(items);
    }
    if (key == 'amount') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BodyLarge(text: '${doubleOrZero(item)}'),
      );
    }
    if (key == 'quantity') {
      return BodyLarge(text: '${doubleOrZero(_itemsSize(items))}');
    }
    return BodyLarge(text: '$item');
  }

  _itemsSize(c) {
    var getItems =
        compose([(x) => x.length, itOrEmptyArray, propertyOrNull('items')]);
    return getItems(c);
  }

  _getTimer(c) {
    var getTimer = propertyOr('timer', (p0) => '');
    var date = DateTime.tryParse(getTimer(c)) ?? DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(date);
  }

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Cash sales tracking",
      showBack: true,
      // backLink: '/sales/',
      showSearch: false,
      onBack: widget.onBackPage,
      searchHint: 'Search product...',
      context: context,
    );
  }

  _tableHeader() {
    // var height = 38.0;
    var smallView = const SizedBox(
      // height: height,
      child: TableLikeListRow([
        LabelMedium(text: 'DATE'),
        LabelMedium(text: 'AMOUNT ( TZS )'),
        LabelMedium(text: 'CUSTOMER'),
      ]),
    );
    var bigView = const SizedBox(
      // height: height,
      child: TableLikeListRow([
        LabelMedium(text: 'DATE'),
        LabelMedium(text: 'AMOUNT ( TZS )'),
        LabelMedium(text: 'ITEM'),
        LabelMedium(text: 'CUSTOMER'),
      ]),
    );
    return getIsSmallScreen(context) ? smallView : bigView;
  }

  List<String> _fields() {
    return getIsSmallScreen(context)
        ? ['date', 'amount', 'customer']
        : ['date', 'amount', 'quantity', 'customer'];
  }

  _loadingView(bool show) {
    return show ? const LinearProgressIndicator(minHeight: 4) : Container();
  }

  _rangePicker() {
    return ReportDateRange(
      onExport: (range) {
        var dateF = DateFormat('yyyy-MM-dd');
        var startD = dateF.format(range?.start ?? DateTime.now());
        var endD = dateF.format(range?.end ?? DateTime.now());
        var title = "Sales cash tracking $startD -> $endD";
        showDialogOrModalSheet(
          dataExportOptions(
            onPdf: () {
              exportPDF(title, _sales);
              Navigator.maybePop(context);
            },
            onCsv: () {
              exportToCsv(title, _sales);
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
          _refresh();
        }
      },
      dateRange: dateRange,
    );
  }

  _updateState(VoidCallback fn) {
    setState(fn);
  }

  _refresh() {
    _updateState(() {
      _loading = true;
    });
    getSalesCashTracking(dateRange).then((value) {
      if (value is List) {
        _updateState(() {
          _sales = value;
        });
      }
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  Widget _dateView(c) {
    var subText = c['channel'] == 'whole' ? 'Wholesale' : 'Retail';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [BodyLarge(text: _getTimer(c)), BodyLarge(text: subText)]),
    );
  }
}
