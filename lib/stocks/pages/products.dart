import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_details.dart';
import 'package:smartstock/stocks/states/products_list.dart';

import '../../core/components/table_like_list.dart';
import '../states/product_loading.dart';

class ProductsPage extends StatefulWidget {
  final args;

  const ProductsPage(this.args, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductPage();
}

class _ProductPage extends State<ProductsPage> {
  _appBar(context) {
    return StockAppBar(
        title: "Products",
        showBack: true,
        backLink: '/stock/',
        showSearch: true,
        onSearch: getState<ProductsListState>().updateQuery,
        searchHint: 'Search...');
  }

  _contextItems() {
    return [
      ContextMenu(
          name: 'Create', pressed: () => navigateTo('/stock/products/create')),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          getState<ProductLoadingState>().update(true);
          // getState<ProductsListState>().refresh();
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

  _fields() =>
      ['product', 'quantity', 'purchase', 'retailPrice', 'wholesalePrice'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextItems()),
              Consumer<ProductLoadingState>(
                builder: (_, state) => _loading(state.loading),
              ),
              _tableHeader(),
              Consumer<ProductsListState>(
                builder: (_, state) => Expanded(
                  child: tableLikeList(
                      onFuture: () async => getStockFromCacheOrRemote(
                            stringLike: state.query,
                            skipLocal: widget.args?.queryParams
                                    ?.containsKey('reload') ==
                                true,
                          ),
                      keys: _fields(),
                      onItemPressed: (item) {
                        showDialogOrModalSheet(
                            productDetail(item, context), context);
                      }
                      // onCell: (key,data)=>Text('@$data')
                      ),
                ),
              ),
              // _tableFooter()
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}
