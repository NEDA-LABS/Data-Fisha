import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/responsive_body.dart';
import 'package:smartstock_pos/core/components/table_context_menu.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/core/models/menu.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/stocks/states/products_list_state.dart';

import '../../core/components/table_like_list.dart';
import '../states/product_loading_state.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key key}) : super(key: key);

  _appBar(context) {
    return topBAr(
      title: "Products",
      showBack: true,
      // !hasEnoughWidth(context),
      backLink: '/stock/',
      showSearch: true,
      onSearch: getState<ProductsListState>().updateQuery,
    );
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
      ContextMenu(name: 'Import', pressed: () => {}),
      ContextMenu(name: 'Export', pressed: () => {}),
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

  // _tableFooter() {
  //   return tableLikeListRow([
  //     tableLikeListTextHeader('Total 1000'),
  //   ]);
  // }

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
                    onFuture: () async =>
                        getStockFromCacheOrRemote(stringLike: state.query),
                    keys: _fields(),
                    // onCell: (key,data)=>Text('@$data')
                  ),
                ),
              ),
              // _tableFooter()
            ],
          ),
        ),
      );
}
