import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/sales/components/refresh_button.dart';
import 'package:smartstock_pos/sales/services/cart.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/top_bar.dart';
import '../components/sales_body.dart';

class RetailPage extends StatelessWidget {
  const RetailPage({Key key}) : super(key: key);

  _appBar(updateState) =>
      StockAppBar(
          title: "Retail",
          backLink: "/sales/",
          showBack: true,
          showSearch: true,
          searchHint: "Search here...",
          onSearch: (text) {
            updateState({"query": text, 'skip': false});
          });

  _fab(states, updateState) =>
      salesRefreshButton(
          onPressed: () => updateState({"skip": true}),
          carts: states['carts'] ?? []);

  @override
  Widget build(var context) =>
      responsiveBody(
        menus: moduleMenus(),
        current: '/sales/',
        onBody: (drawer) =>
            ActiveComponent(
              builder: (context, states, updateState) =>
                  Scaffold(
                    appBar: _appBar(updateState),
                    floatingActionButton: _fab(states, updateState),
                    body: FutureBuilder(
                      initialData: states['carts'] ?? [],
                      future: getStockFromCacheOrRemote(
                        skipLocal: states['skip'],
                        stringLike: states['query'],
                      ),
                      builder: (context, snapshot) =>
                          _getView(
                            snapshot,
                            states['carts'] ?? [],
                                (cart) {
                              var carts = addToCarts(
                                  states['carts'] ?? [], cart);
                              updateState({"carts": carts, 'query': ''});
                              navigator().maybePop();
                            },
                            context
                          ),
                    ),
                  ),
              initialState: const {'skip': false, 'query': ''},
            ),
      );

  _getView(snapshot, carts, onAddToCart, context) {
    // var getView = ifDoElse(
    //     (x) => false,
    var isLoading = snapshot is AsyncSnapshot &&
        snapshot.connectionState == ConnectionState.waiting;
    // (_) => Container(
    //     color: Colors.white,
    //     child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(children: [
    //           const CircularProgressIndicator(),
    //           Container(height: 20),
    //           const Text("Loading products...")
    //         ]))),
    // (x) =>
    return Column(
      children: [
        isLoading?const LinearProgressIndicator(): const SizedBox(height: 0),
        Expanded(child: salesBody(
          wholesale: false,
          products: snapshot.data ?? [],
          onAddToCart: onAddToCart,
          carts: carts,
          context: context,
        ))
      ],
    );
    // );
    // return getView(snapshot);
  }
}
