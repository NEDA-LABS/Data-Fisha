import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/configurations.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/navigation.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_details.dart';
import 'package:smartstock/stocks/pages/product_create.dart';

class ProductsPage extends StatefulWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const ProductsPage({Key? key, required this.onGetModulesMenu})
      : super(key: key);

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
      menus: widget.onGetModulesMenu(context),
      current: '/stock/',
      sliverAppBar: getSliverSmartStockAppBar(
        title: "Products",
        showBack: true,
        backLink: '/stock/',
        showSearch: true,
        onBack: onAppGoBack(context),
        onSearch: _updateQuery,
        searchHint: 'Search...',
        context: context,
      ),
      staticChildren: [
        _ifLargerScreen(tableContextMenu(_getContextItems())),
        _loading(_isLoading),
        _ifLargerScreen(_tableHeader())
      ],
      dynamicChildBuilder: getIsSmallScreen(context)
          ? _smallScreenChildBuilder
          : _largerScreenChildBuilder,
      totalDynamicChildren: _products.length,
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  _ifLargerScreen(view) => getIsSmallScreen(context) ? Container() : view;

  ContextMenu _getAddProductMenu() {
    return ContextMenu(
      name: 'Add product',
      pressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductCreatePage(
            onGetModulesMenu: widget.onGetModulesMenu,
          ),
        ));
      },
    );
  }

  ContextMenu _getAddServiceMenu() {
    return ContextMenu(
      name: 'Add service',
      pressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductCreatePage(
            onGetModulesMenu: widget.onGetModulesMenu,
          ),
        ));
      },
    );
  }

  ContextMenu _getReloadMenu() {
    return ContextMenu(name: 'Reload', pressed: _reload);
  }

  _getContextItems() {
    return [
      _getAddProductMenu(),
      _getAddServiceMenu(),
      _getReloadMenu()
      // ContextMenu(name: 'Import', pressed: () => {}),
      // ContextMenu(name: 'Export', pressed: () => {}),
    ];
  }

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
    getStockFromCacheOrRemote(
      stringLike: _query,
      skipLocal: _skipLocal,
    ).then((data) {
      _products = data;
    }).catchError((error) {
      showInfoDialog(context, error);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
        _skipLocal = false;
      });
    });
  }

  _productItemClicked(item) => showDialogOrModalSheet(
      ProductDetail(item: item, onGetModulesMenu: widget.onGetModulesMenu),
      context);

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
                leading: const Icon(Icons.card_giftcard),
                trailing: const Icon(Icons.chevron_right),
                title: Text(_getAddProductMenu().name),
                onTap: _getAddProductMenu().pressed,
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.home_repair_service_rounded),
                trailing: const Icon(Icons.chevron_right),
                title: Text(_getAddServiceMenu().name),
                onTap: _getAddServiceMenu().pressed,
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(_getReloadMenu().name),
                trailing: const Icon(Icons.chevron_right),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 2),
          onTap: () => _productItemClicked(_products[index]),
          title: TableLikeListTextDataCell('${_products[index]['product']}'),
          subtitle: _renderStockStatus(_products[index], appendQuantity: true),
          trailing: TableLikeListTextDataCell(
              compactNumber('${_products[index]['purchase']}')),
        ),
        const SizedBox(height: 5),
        const HorizontalLine(),
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
        const HorizontalLine()
      ],
    );
  }
}
