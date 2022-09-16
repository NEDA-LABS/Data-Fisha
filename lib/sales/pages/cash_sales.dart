import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/cash_sale_details.dart';
import 'package:smartstock/sales/services/sales.dart';
import 'package:timeago/timeago.dart' as timeago;

class CashSalesPage extends StatefulWidget {
  const CashSalesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CashSalesPage();
}

class _CashSalesPage extends State<CashSalesPage> {
  bool _loading = false;
  String _query = '';
  int size = 20;
  List _sales = [];

  _onItemPressed(item) {
    showDialogOrModalSheet(cashSaleDetail(context, item), context);
  }

  Widget _onCell(a, b, c) {
    if (a == 'product') {
      return _productView(b, c);
    }
    if (a == 'amount') {
      return Text('${doubleOrZero(b)}');
    }
    return Text('$b');
  }

  _appBar(context) {
    return StockAppBar(
      title: "Cash Sales",
      showBack: true,
      backLink: '/sales/',
      showSearch: true,
      onSearch: (d) {
        setState(() {
          _query = d;
        });
        _refresh();
      },
      searchHint: 'Search product...',
    );
  }

  _contextSales(context) {
    return [
      ContextMenu(
        name: 'Add Retail',
        pressed: () => navigateTo('/sales/cash/retail'),
      ),
      ContextMenu(
        name: 'Add Wholesale',
        pressed: () => navigateTo('/sales/cash/whole'),
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    return SizedBox(
      height: 38,
      child: tableLikeListRow([
        tableLikeListTextHeader('Product'),
        tableLikeListTextHeader('Amount ( TZS )'),
        tableLikeListTextHeader('Quantity'),
        tableLikeListTextHeader('Customer'),
      ]),
    );
  }

  _fields() => ['product', 'amount', 'quantity', 'customer'];

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => responsiveBody(
      menus: moduleMenus(),
      current: '/sales/',
      onBody: (d) => Scaffold(appBar: _appBar(context), body: _body()));

  _loadMore() {
    setState(() {
      _loading = true;
    });
    var getSales = _prepareGetSales(_query, size, true);
    getSales(_sales).then((value) {
      if (value is List) {
        _sales.addAll(value);
        _sales = _sales.toSet().toList();
        setState(() {});
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _refresh() {
    setState(() {
      _loading = true;
    });
    var getSales = _prepareGetSales(_query, size, false);
    getSales(_sales).then((value) {
      if (value is List) {
        _sales = value;
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _defaultLast() {
    var dF = DateFormat('yyyy-MM-ddTHH:mm');
    var date = DateTime.now().add(const Duration(days: 1));
    return dF.format(date);
  }

  _prepareGetSales(String product, size, bool more) {
    return ifDoElse(
      (sales) => sales is List && sales.isNotEmpty,
      (sales) {
        var last = more ? sales.last['timer'] : _defaultLast();
        return getCashSalesFromCacheOrRemote(last, size, product);
      },
      (sales) => getCashSalesFromCacheOrRemote(_defaultLast(), size, product),
    );
  }

  Widget _productView(b, c) {
    var date = DateTime.tryParse(c['timer']) ?? DateTime.now();
    var textStyle = const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
        height: 2.0,
        overflow: TextOverflow.ellipsis);
    var mainTextStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis);
    var subText = '${timeago.format(date)}   '
        '${c['channel'] == 'whole' ? '| Wholesale' : '| Retail'}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$b', style: mainTextStyle),
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
        onLoadMore: () async => _loadMore(),
        loading: _loading
      ),
    );
  }

  _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _loadingView(_loading),
        tableContextMenu(_contextSales(context)),
        _tableHeader(),
        _salesList(),
      ],
    );
  }
}
