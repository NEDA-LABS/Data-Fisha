import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/configs.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/SearchFilter.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/stocks/components/product_details.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/pages/product_create.dart';
import 'package:smartstock/stocks/services/inventories_filters.dart';

class ProductsPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;
  final Map<String, dynamic Function(dynamic)> initialFilter;

  const ProductsPage({
    Key? key,
    this.initialFilter = const {},
    required this.onBackPage,
    required this.onChangePage,
  }) : super(key: key, pageName: 'ProductsPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductsPage> {
  Map<String, dynamic Function(dynamic)> _filters = {};
  bool _isLoading = false;
  bool _isExporting = false;
  bool _skipLocal = false;
  List _allProducts = [];

  @override
  void initState() {
    _filters = widget.initialFilter;
    _getProducts('');
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      current: '/stock/',
      backgroundColor: Theme.of(context).colorScheme.surface,
      sliverAppBar: _getAppBar(),
      staticChildren: [
        _ifLargerScreen(getTableContextMenu(_getContextItems())),
        _loading(_isLoading),
        _ifLargerScreen(_tableHeader())
      ],
      dynamicChildBuilder: getIsSmallScreen(context)
          ? _smallScreenChildBuilder
          : _largerScreenChildBuilder,
      totalDynamicChildren: _getFilteredProducts().length,
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more),
      ),
    );
  }

  _getAppBar() {
    return SliverSmartStockAppBar(
      title: "Products",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onBack: widget.onBackPage,
      onSearch: _updateQuery,
      searchHint: 'Search...',
      context: context,
      filters: [
        SearchFilter(
          name: 'Negatives',
          selected: _filters['negative'] != null,
          onClick: () {
            var name = 'negative';
            setState(() {
              if (_filters.containsKey(name)) {
                _filters.removeWhere((key, value) => key == name);
              } else {
                _filters = getNegativeProductFilter(name);
              }
            });
          },
        ),
        SearchFilter(
          name: 'Zeros',
          selected: _filters['zeros'] != null,
          onClick: () {
            setState(() {
              var filterName = 'zeros';
              if (_filters.containsKey(filterName)) {
                _filters.removeWhere((key, value) => key == filterName);
              } else {
                _filters = getZeroProductsFilter(filterName);
              }
            });
          },
        ),
        SearchFilter(
          name: 'Positives',
          selected: _filters['positives'] != null,
          onClick: () {
            setState(() {
              var name = 'positives';
              if (_filters.containsKey(name)) {
                _filters.removeWhere((key, value) => key == name);
              } else {
                _filters = getPositiveProductsFilter(name);
              }
            });
          },
        ),
        SearchFilter(
          name: 'Expired',
          selected: _filters['expired'] != null,
          onClick: () {
            var name = 'expired';
            setState(() {
              if (_filters.containsKey(name)) {
                _filters.removeWhere((key, value) => key == name);
              } else {
                _filters = getExpiredProductsFilter(name);
              }
            });
          },
        ),
        SearchFilter(
          name: 'Near to expire',
          selected: _filters['near_expired'] != null,
          onClick: () {
            var name = 'near_expired';
            setState(() {
              if (_filters.containsKey(name)) {
                _filters.removeWhere((key, value) => key == name);
              } else {
                _filters = getNearExpiredProductsFilter(name);
              }
            });
          },
        )
      ],
    );
  }

  List _getFilteredProducts() {
    dynamic Function(dynamic p1) filter =
        _filters.isNotEmpty ? _filters.values.toList()[0] : (v) => true;
    return _allProducts.where((e) => filter(e) == true).toList();
  }

  _ifLargerScreen(view) => getIsSmallScreen(context) ? Container() : view;

  ContextMenu _getAddProductMenu() {
    return ContextMenu(
      name: 'Add product',
      pressed: () {
        widget.onChangePage(
          ProductCreatePage(
            inventoryType: InventoryType.product,
            onBackPage: widget.onBackPage,
          ),
        );
      },
    );
  }

  // ContextMenu _getAddNonStockableProductMenu() {
  //   return ContextMenu(
  //     name: 'Add non-stock product',
  //     pressed: () {
  //       widget.onChangePage(
  //         ProductCreatePage(
  //           inventoryType: InventoryType.nonStockProduct,
  //           onBackPage: widget.onBackPage,
  //         ),
  //       );
  //     },
  //   );
  // }

  // ContextMenu _getAddServiceMenu() {
  //   return ContextMenu(
  //     name: 'Add raw material',
  //     pressed: () {
  //       widget.onChangePage(
  //         ProductCreatePage(
  //           inventoryType: InventoryType.rawMaterial,
  //           onBackPage: widget.onBackPage,
  //         ),
  //       );
  //     },
  //   );
  // }

  ContextMenu _getReloadMenu() {
    return ContextMenu(name: 'Reload', pressed: _reload);
  }

  ContextMenu _getExportMenu() {
    return ContextMenu(
      name: _isExporting ? 'Exporting...' : 'Export',
      pressed: _isExporting
          ? () => {}
          : () {
              setState(() {
                _isLoading = true;
                _isExporting = true;
              });
              getStockFromCacheOrRemote(
                stringLike: '',
                skipLocal: true,
              ).then((data) {
                _allProducts = data;
                exportToCsv('stock_export', data);
              }).catchError((error) {
                showInfoDialog(context, error);
              }).whenComplete(() {
                setState(() {
                  _isLoading = false;
                  _skipLocal = false;
                  _isExporting = false;
                });
              });
            },
    );
  }

  _getContextItems() {
    return [
      _getAddProductMenu(),
      // _getAddNonStockableProductMenu(),
      // _getAddServiceMenu(),
      _getExportMenu(),
      _getReloadMenu(),
      // ContextMenu(name: 'Import', pressed: () => {}),
      // ContextMenu(name: 'Export', pressed: () => {}),
    ];
  }

  _tableHeader() => const TableLikeListRow([
        TableLikeListHeaderCell('Name'),
        TableLikeListHeaderCell('Quantity'),
        TableLikeListHeaderCell('Purchase ( Tsh )'),
        TableLikeListHeaderCell('Retail ( Tsh )'),
        TableLikeListHeaderCell("Wholesale ( Tsh )"),
        TableLikeListHeaderCell("Status"),
      ]);

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  _updateQuery(String q) {
    _getProducts(q);
  }

  _getProducts(String query) async {
    setState(() {
      _isLoading = true;
    });
    if (query.startsWith('-1:')) {
      var inventory = _allProducts.firstWhere((element) {
        var getBarCode = propertyOrNull('barcode');
        var barCode = getBarCode(element);
        var barCodeQ = query.replaceFirst('-1:', '');
        return barCode == barCodeQ && barCodeQ != '' && barCodeQ != '_';
      }, orElse: () => null);
      // var isBarCode = _allProducts.map(propertyOrNull('barcode')).toList().contains(query);
      if (inventory != null) {
        _productItemClicked(inventory);
      }
      setState(() {
        _isLoading = false;
        _skipLocal = false;
      });
    } else {
      getStockFromCacheOrRemote(
        stringLike: query,
        skipLocal: _skipLocal,
      ).then((data) {
        _allProducts = data;
      }).catchError((error) {
        showInfoDialog(context, error);
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
          _skipLocal = false;
        });
      });
    }
  }

  _productItemClicked(item) => showDialogOrModalSheet(
        ProductDetail(
          item: item,
          onChangePage: widget.onChangePage,
          onBackPage: widget.onBackPage,
        ),
        context,
      );

  _outStyle() => TextStyle(
      color: criticalColor, fontWeight: FontWeight.w400, fontSize: 14);

  _inStyle() =>
      TextStyle(color: healthColor, fontWeight: FontWeight.w400, fontSize: 14);

  _renderStockStatus(product, {appendQuantity = false}) => ifDoElse(
      (_) => doubleOrZero(_['quantity']) > 0 || _['stockable'] == false,
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
              Text(_['stockable'] == false ? 'N/A' : 'In stock',
                  style: _inStyle()),
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
              onTap: () {
                _getAddProductMenu().pressed();
                Navigator.of(context).maybePop();
              },
            ),
            const HorizontalLine(),
            // ListTile(
            //   leading: const Icon(Icons.free_breakfast),
            //   trailing: const Icon(Icons.chevron_right),
            //   title: Text(_getAddNonStockableProductMenu().name),
            //   onTap: () {
            //     _getAddNonStockableProductMenu().pressed();
            //     Navigator.of(context).maybePop();
            //   },
            // ),
            const HorizontalLine(),
            // ListTile(
            //   leading: const Icon(Icons.home_repair_service_rounded),
            //   trailing: const Icon(Icons.chevron_right),
            //   title: Text(_getAddServiceMenu().name),
            //   onTap: () {
            //     _getAddServiceMenu().pressed();
            //     Navigator.of(context).maybePop();
            //   },
            // ),
            const HorizontalLine(),
            ListTile(
              leading: const Icon(Icons.file_download_rounded),
              title: Text(_getExportMenu().name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _getExportMenu().pressed();
                Navigator.of(context).maybePop();
              },
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
      context,
    );
  }

  _reload() {
    _skipLocal = true;
    _getProducts('');
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          onTap: () => _productItemClicked(_getFilteredProducts()[index]),
          title: TableLikeListTextDataCell(
              '${_getFilteredProducts()[index]['product']}'),
          subtitle: _renderStockStatus(_getFilteredProducts()[index],
              appendQuantity: true),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).primaryColor,
          ),
          // dense: true,
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
          onTap: () => _productItemClicked(_getFilteredProducts()[index]),
          child: TableLikeListRow([
            TableLikeListTextDataCell(
                '${_getFilteredProducts()[index]['product']}'),
            TableLikeListTextDataCell(
                '${formatNumber(_getFilteredProducts()[index]['quantity'])}'),
            TableLikeListTextDataCell(
                '${formatNumber(_getFilteredProducts()[index]['purchase'])}'),
            TableLikeListTextDataCell(
                '${formatNumber(_getFilteredProducts()[index]['retailPrice'])}'),
            TableLikeListTextDataCell(
                '${formatNumber(_getFilteredProducts()[index]['wholesalePrice'])}'),
            _renderStockStatus(_getFilteredProducts()[index]),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }
}
