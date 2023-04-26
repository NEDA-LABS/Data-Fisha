import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/components/date_range.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/report/services/report.dart';
import 'package:smartstock/sales/components/sale_cash_details.dart';

class SalesCashTrackingPage extends StatefulWidget {
  const SalesCashTrackingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesCashTrackingPage> {
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
      menus: getAppModuleMenus(context),
      current: '/report/',
      sliverAppBar: _appBar(context),
      onBody: (d) {
        return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [_appBar(context)],
            body: Scaffold(drawer: d, body: _body()));
      },
    );
  }

  _onItemPressed(item) {
    showDialogOrModalSheet(
        CashSaleDetail(sale: item, pageContext: context), context);
  }

  Widget _onCell(a, b, c) {
    if (a == 'date') {
      return _dateView(c);
    }
    if (a == 'amount') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text('${doubleOrZero(b)}'),
      );
    }
    if (a == 'quantity') {
      return Text('${doubleOrZero(_itemsSize(c))}');
    }
    return Text('$b');
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
    // return '${getTimer(c)}'.replaceAll('T', ' ');
    // var getItems = propertyOr('items', (p0) => []);
    // var items = itOrEmptyArray(getItems(c)) as List;
    // var productsName = [];
    // for (var item in items) {
    //   var getProduct =
    //       compose([propertyOrNull('product'), propertyOrNull('stock')]);
    //   productsName.add(getProduct(item));
    // }
    // return productsName.length > 2
    //     ? '${productsName.sublist(1, 3).join(', ')} & more'
    //     : productsName.join(',');
  }

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Cash sales tracking",
      showBack: true,
      // backLink: '/sales/',
      showSearch: false,
      onBack: () {
        Navigator.of(context).canPop()
            ? Navigator.of(context).pop()
            : Navigator.of(context).pushNamed('/');
      },
      searchHint: 'Search product...',
      context: context,
    );
  }

  _tableHeader() {
    var height = 38.0;
    var smallView = SizedBox(
      height: height,
      child: const TableLikeListRow([
        TableLikeListTextHeaderCell('Date'),
        TableLikeListTextHeaderCell('Amount ( TZS )'),
        TableLikeListTextHeaderCell('Customer'),
      ]),
    );
    var bigView = SizedBox(
      height: height,
      child: const TableLikeListRow([
        TableLikeListTextHeaderCell('Date'),
        TableLikeListTextHeaderCell('Amount ( TZS )'),
        TableLikeListTextHeaderCell('Items'),
        TableLikeListTextHeaderCell('Customer'),
      ]),
    );
    return getIsSmallScreen(context) ? smallView : bigView;
  }

  _fields() {
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

  _refresh() {
    setState(() {
      _loading = true;
    });
    getSalesCashTracking(dateRange).then((value) {
      if (value is List) {
        _sales = value;
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  Widget _dateView(c) {
    // var date = DateTime.tryParse(c['timer']) ?? DateTime.now();
    var textStyle = const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
        height: 2.0,
        overflow: TextOverflow.ellipsis);
    var mainTextStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis);
    var subText = c['channel'] == 'whole' ? 'Wholesale' : 'Retail';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_getTimer(c), style: mainTextStyle),
        Text(subText, style: textStyle)
      ]),
    );
  }

  _salesList() {
    return Expanded(
      child: TableLikeList(
        onFuture: () async => _sales,
        keys: _fields(),
        onCell: _onCell,
        onItemPressed: _onItemPressed,
        // onLoadMore: () async => _loadMore(),
        loading: _loading,
      ),
    );
  }

  _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _loadingView(_loading),
        _rangePicker(),
        _tableHeader(),
        _salesList(),
      ],
    );
  }
}
