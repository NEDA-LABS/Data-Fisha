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
import 'package:smartstock/sales/components/sale_cash_details.dart';
import 'package:smartstock/sales/services/sales.dart';
import 'package:timeago/timeago.dart' as timeago;

class SalesCashPage extends StatefulWidget {
  const SalesCashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesCashPage> {
  bool _loading = false;
  String _query = '';
  int size = 20;
  List _sales = [];

  _onItemPressed(item) {
    showDialogOrModalSheet(
        CashSaleDetail(sale: item, pageContext: context), context);
  }

  Widget _onCell(a, b, c) {
    if (a == 'product') {
      return _productView(c);
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

  _getSomeProducts(c) {
    var getItems = propertyOr('items', (p0) => []);
    var items = itOrEmptyArray(getItems(c)) as List;
    var productsName = [];
    for (var item in items) {
      var getProduct =
          compose([propertyOrNull('product'), propertyOrNull('stock')]);
      productsName.add(getProduct(item));
    }
    return productsName.length > 2
        ? '${productsName.sublist(1, 3).join(', ')} & more'
        : productsName.join(',');
  }

  _appBar(context) {
    return StockAppBar(
      title: "Cash Sales",
      showBack: true,
      backLink: '/sales/',
      showSearch: false,
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
    var height = 38.0;
    var smallView = SizedBox(
      height: height,
      child: tableLikeListRow([
        tableLikeListTextHeader('Products'),
        tableLikeListTextHeader('Customer'),
      ]),
    );
    var bigView = SizedBox(
      height: height,
      child: tableLikeListRow([
        tableLikeListTextHeader('Products'),
        tableLikeListTextHeader('Amount ( TZS )'),
        tableLikeListTextHeader('Items'),
        tableLikeListTextHeader('Customer'),
      ]),
    );
    return isSmallScreen(context) ? smallView : bigView;
  }

  _fields() => isSmallScreen(context)
      ? ['product', 'customer']
      : ['product', 'amount', 'quantity', 'customer'];

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

  Widget _productView(c) {
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
        Text(_getSomeProducts(c), style: mainTextStyle),
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
        tableContextMenu(_contextSales(context)),
        _tableHeader(),
        _salesList(),
      ],
    );
  }
}
