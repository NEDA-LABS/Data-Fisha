import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/refresh_button.dart';
import 'package:smartstock/sales/services/cart.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/top_bar.dart';
import '../components/cart_drawer.dart';
import '../components/sales_body.dart';

class SalePage extends StatelessWidget {
  final String title;
  final bool wholesale;

  SalePage({
    @required this.title,
    @required this.wholesale,
    Key key,
  }) : super(key: key);

  final _getSkip = propertyOr('skip', (p0) => false);
  final _getQuery = propertyOr('query', (p0) => '');
  final _getCarts = propertyOr('carts', (p0) => []);
  final _getCustomer = propertyOr('customer', (p0) => '');

  _hasCarts(states) => _getCarts(states).length > 0;

  _future(states) => getStockFromCacheOrRemote(
      skipLocal: _getSkip(states), stringLike: _getQuery(states));

  _onAddToCart(states, updateState) => (cart) {
        var carts = appendToCarts(cart, _getCarts(states));
        updateState({"carts": carts, 'query': ''});
        navigator().maybePop();
      };

  _onShowCheckoutSheet(states, updateState, context, wholesale) =>
      () => fullScreeDialog(
          context,
          (refresh) =>
              _cartDrawer(states, updateState, context, wholesale, refresh));

  _appBar(updateState) => StockAppBar(
      title: title,
      backLink: "/sales/",
      showBack: true,
      showSearch: true,
      searchHint: "Search here...",
      onSearch: (text) {
        updateState({"query": text, 'skip': false});
      });

  _fab(states, updateState) => salesRefreshButton(
      onPressed: () => updateState({"skip": true}),
      carts: states['carts'] ?? []);

  _isLoading(snapshot) =>
      snapshot is AsyncSnapshot &&
      snapshot.connectionState == ConnectionState.waiting;

  _getView(carts, onAddToCart, onShowCheckout) =>
      (context, snapshot) => Column(children: [
            _isLoading(snapshot)
                ? const LinearProgressIndicator()
                : const SizedBox(height: 0),
            Expanded(
                child: salesBody(
                    wholesale: wholesale,
                    products: snapshot.data ?? [],
                    onAddToCart: onAddToCart,
                    onShowCheckout: onShowCheckout,
                    carts: carts,
                    context: context))
          ]);

  @override
  Widget build(var context) => ActiveComponent(
      initialState: const {'skip': false, 'query': ''},
      builder: (context, states, updateState) => responsiveBody(
          menus: moduleMenus(),
          office: 'Menu',
          current: '/sales/',
          rightDrawer: _hasCarts(states)
              ? SizedBox(
                  width: 350,
                  child: _cartDrawer(states, updateState, context, wholesale, (a){}))
              : null,
          onBody: (drawer) => Scaffold(
              appBar: states['hab'] == true ? null : _appBar(updateState),
              floatingActionButton: _fab(states, updateState),
              body: FutureBuilder(
                  initialData: _getCarts(states),
                  future: _future(states),
                  builder: _getView(
                      _getCarts(states),
                      _onAddToCart(states, updateState),
                      _onShowCheckoutSheet(
                          states, updateState, context, wholesale))))));

  _cartDrawer(states, updateState, context, wholesale, refresh) => cartDrawer(
        onAddItem: (id, q) {
          var addCart = _prepareAddCartQuantity(states, updateState);
          addCart(id, q);
          refresh((){});
        },
        onRemoveItem: (id) {
          var remove = _prepareRemoveCart(states, updateState);
          remove(id);
          refresh((){});
        },
        onCheckout: _prepareCheckout(states, updateState, context),
        carts: _getCarts(states),
        wholesale: wholesale,
        context: context,
        customer: _getCustomer(states),
        onCustomer: (d) => updateState({"customer": d}),
      );

  _prepareRemoveCart(states, updateState) => (String id) =>
      updateState({'carts': removeCart(id, states['carts'] ?? [])});

  _prepareAddCartQuantity(states, updateState) => (String id, int q) =>
      updateState({'carts': updateCartQuantity(id, q, states['carts'] ?? [])});

  _prepareCheckout(states, updateState, context) => (discount) async {
        var customer = '${states['customer'] ?? ''}';
        var carts = states['carts'];
        return printAndSaveCart(carts, discount, customer, wholesale)
            .then((value) {
          updateState({'carts': [], 'customer': ''});
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Done save sale')));
          navigator().maybePop();
        }).catchError((error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        });
      };
}
