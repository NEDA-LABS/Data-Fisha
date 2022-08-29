import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/sales/components/refresh_button.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/top_bar.dart';
import '../components/sales_body.dart';

class RetailPage extends StatelessWidget {
  RetailPage({Key key}) : super(key: key);

  @override
  Widget build(var context) => responsiveBody(
      menus: moduleMenus(),
      current: '/sales/',
      onBody: (drawer) => ActiveComponent(
            builder: (context, states, updateState) => Scaffold(
                appBar: StockAppBar(
                    title: "Retail",
                    backLink: "/sales/",
                    showBack: true,
                    showSearch: true,
                    searchHint: "Search here...",
                    onSearch: (text) {
                      updateState({"query": text, 'skip': false});
                    }),
                // drawer: drawer,
                floatingActionButton: salesRefreshButton(
                    onPressed: () => updateState({"skip": true}),
                    carts: states['carts'] ?? []),
                body: FutureBuilder(
                    future: getStockFromCacheOrRemote(
                        skipLocal: states['skip'], stringLike: states['query']),
                    builder: _futureBuilder(
                      onAddToCart: (cart) {
                        print(cart.quantity);
                        updateState({
                          "carts": [...states['carts'] ?? [], cart]
                        });
                        navigator().maybePop();
                      },
                    ))),
            initialState: const {'skip': false, 'query': ''},
          ));

  Widget Function(BuildContext, AsyncSnapshot) _futureBuilder({
    @required onAddToCart,
  }) =>
      (context, snapshot) => _getView(snapshot, onAddToCart);

  _getView(snapshot, onAddToCart) {
    var getView = ifDoElse(
        (x) =>
            x is AsyncSnapshot && x.connectionState == ConnectionState.waiting,
        (_) => Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  const CircularProgressIndicator(),
                  Container(height: 20),
                  const Text("Loading products...")
                ]))),
        (x) => salesBody(
            wholesale: false,
            products: x.data ?? [],
            onAddToCart: onAddToCart));
    return getView(snapshot);
  }
}
