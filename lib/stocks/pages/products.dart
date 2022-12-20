import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/configurations.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_details.dart';

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
      sliverAppBar: StockAppBar(
        title: "Products",
        showBack: true,
        backLink: '/stock/',
        showSearch: true,
        onSearch: _updateQuery,
        searchHint: 'Search...',
        context: context,
      ),
      staticChildren: [
        _ifLargerScreen(context, tableContextMenu(_contextItems())),
        _loading(_isLoading),
        _ifLargerScreen(context, _tableHeader())
      ],
      dynamicChildBuilder: isSmallScreen(context)
          ? _smallScreenChildBuilder
          : _largerScreenChildBuilder,
      totalDynamicChildren: _products.length,
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more_outlined),
      ),
    );
  }

  _ifLargerScreen(context, view) => isSmallScreen(context) ? Container() : view;

  _contextItems() => [
        ContextMenu(
            name: 'Add', pressed: () => navigateTo('/stock/products/create')),
        ContextMenu(
          name: 'Reload',
          pressed: _reload,
        ),
        // ContextMenu(name: 'Import', pressed: () => {}),
        // ContextMenu(name: 'Export', pressed: () => {}),
      ];

  _tableHeader() => const TableLikeListRow([
        TableLikeListTextHeaderCell('Name'),
        TableLikeListTextHeaderCell('Quantity'),
        TableLikeListTextHeaderCell('Purchase ( Tsh )'),
        TableLikeListTextHeaderCell('Retail ( Tsh )'),
        TableLikeListTextHeaderCell("Wholesale ( Tsh )"),
        TableLikeListTextHeaderCell("Status"),
      ]);

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

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
      _skipLocal = false;
    });
  }

  _productItemClicked(item) =>
      showDialogOrModalSheet(productDetail(item, context), context);

  _outStyle() => TextStyle(
      color: criticalColor, fontWeight: FontWeight.w400, fontSize: 14);

  _inStyle() =>
      TextStyle(color: healthColor, fontWeight: FontWeight.w400, fontSize: 14);

  _renderStockStatus(product, {appendQuantity = false}) => ifDoElse(
      (_) => doubleOrZero(_['quantity']) > 0,
      (_) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                    color: healthColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(right: 8),
              ),
              Text('In stock', style: _inStyle()),
              appendQuantity
                  ? Text(' ( ${formatNumber(_['quantity'])} )',
                      style: _inStyle())
                  : Container(),
            ],
          ),
      (_) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                    color: criticalColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(right: 8),
              ),
              Text('Out stock', style: _outStyle()),
              appendQuantity
                  ? Text(' ( ${formatNumber(_['quantity'])} )',
                      style: _outStyle())
                  : Container(),
            ],
          ))(product);

  void _showMobileContextMenu(context) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Create a product'),
                onTap: () => navigateTo('/stock/products/create'),
              ),
              horizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload products'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _reload();
                },
              ),
            ],
          ),
        ),
        context);
  }

  _reload() {
    _skipLocal = true;
    _getProducts();
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => _productItemClicked(_products[index]),
          title: TableLikeListTextDataCell('${_products[index]['product']}'),
          subtitle: _renderStockStatus(_products[index], appendQuantity: true),
          trailing: TableLikeListTextDataCell(
              compactNumber('${_products[index]['retailPrice']}')),
        ),
        const SizedBox(height: 5),
        horizontalLine(),
      ],
    );
  }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => _productItemClicked(_products[index]),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${_products[index]['product']}'),
            TableLikeListTextDataCell(
                '${formatNumber(_products[index]['quantity'])}'),
            TableLikeListTextDataCell(
                '${formatNumber(_products[index]['purchase'])}'),
            TableLikeListTextDataCell(
                '${formatNumber(_products[index]['retailPrice'])}'),
            TableLikeListTextDataCell(
                '${formatNumber(_products[index]['wholesalePrice'])}'),
            _renderStockStatus(_products[index]),
          ]),
        ),
        horizontalLine()
      ],
    );
  }
}
