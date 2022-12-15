import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_details.dart';
import 'package:smartstock/stocks/states/product_loading.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductsPage> {
  String _query = '';
  bool _isLoading = false;
  bool _skipLocal = false;
  List _products = [];

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      menus: moduleMenus(),
      current: '/stock/',
      sliverAppBar: _appBar(context),
      onBody: (d) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            tableContextMenu(_contextItems()),
            _loading(_isLoading),
            _tableHeader(),
            Expanded(
              child: TableLikeList(
                onFuture: () async => _products,
                keys: _fields,
                onItemPressed: _productItemClicked,
                onCell: _onRenderCellView,
              ),
            ),
          ],
        );
      },
    );
  }

  _appBar(context) {
    return StockAppBar(
      title: "Products",
      showBack: true,
      backLink: '/stock/',
      // showSearch: false,
      // onSearch: _updateQuery,
      // searchHint: 'Search...',
      context: context,
    );
  }

  _contextItems() {
    return [
      ContextMenu(
          name: 'Add', pressed: () => navigateTo('/stock/products/create')),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          getState<ProductLoadingState>().update(true);
        },
      ),
      // ContextMenu(name: 'Import', pressed: () => {}),
      // ContextMenu(name: 'Export', pressed: () => {}),
    ];
  }

  _tableHeader() {
    return tableLikeListRow([
      tableLikeListTextHeader('Name'),
      tableLikeListTextHeader('Quantity'),
      tableLikeListTextHeader('Purchase ( Tsh )'),
      tableLikeListTextHeader('Retail ( Tsh )'),
      tableLikeListTextHeader("Wholesale ( Tsh )"),
    ]);
  }

  get _fields =>
      ['product', 'quantity', 'purchase', 'retailPrice', 'wholesalePrice'];

  _loading(bool show) {
    return show ? const LinearProgressIndicator(minHeight: 4) : Container();
  }

  _updateQuery(String q) {
    _query = q;
    _getProducts();
  }

  _getProducts() async {
    setState(() {
      _isLoading = true;
    });
    var data = await getStockFromCacheOrRemote(
      stringLike: _query,
      skipLocal: _skipLocal,
    );
    setState(() {
      _products = data;
      _isLoading = false;
    });
  }

  _productItemClicked(item) {
    showDialogOrModalSheet(productDetail(item, context), context);
  }

  Widget _onRenderCellView(key, data, c) {
    if (key == 'product') return Text('$data');
    return Text('${doubleOrZero(data)}');
  }
}
