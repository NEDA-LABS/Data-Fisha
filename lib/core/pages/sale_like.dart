import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/core/components/cart_drawer.dart';
import 'package:smartstock/core/components/refresh_button.dart';
import 'package:smartstock/core/components/sales_like_body.dart';
import 'package:smartstock/core/services/cart.dart';

class SaleLikePage extends StatelessWidget {
  final String title;
  final bool wholesale;
  final String backLink;
  final String customerLikeLabel;
  final String checkoutCompleteMessage;
  final dynamic Function(dynamic) onGetPrice;
  final Future Function({bool skipLocal}) onCustomerLikeList;
  final Widget Function() onCustomerLikeAddWidget;
  final Function(dynamic product, Function(dynamic)) onAddToCartView;
  final Future Function(List<dynamic>, String, dynamic) onSubmitCart;

  SaleLikePage({
    required this.title,
    required this.wholesale,
    required this.onSubmitCart,
    required this.backLink,
    required this.onGetPrice,
    required this.onAddToCartView,
    required this.onCustomerLikeList,
    required this.onCustomerLikeAddWidget,
    required this.checkoutCompleteMessage,
    this.customerLikeLabel = 'Choose customer',
    Key? key,
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

  _onShowCheckoutSheet(states, updateState, context) => () => fullScreeDialog(
      context,
      (refresh) =>
          _cartDrawer(states, updateState, context, wholesale, refresh));

  _appBar(updateState) => StockAppBar(
      title: title,
      backLink: backLink,
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

  _getView(carts, onAddToCart, onAddToCartView, onShowCheckout, onGetPrice) =>
      (context, snapshot) => Column(children: [
            _isLoading(snapshot)
                ? const LinearProgressIndicator()
                : const SizedBox(height: 0),
            Expanded(
                child: salesLikeBody(
                    onAddToCart: onAddToCart,
                    wholesale: wholesale,
                    products: snapshot.data ?? [],
                    onAddToCartView: onAddToCartView,
                    onShowCheckout: onShowCheckout,
                    onGetPrice: onGetPrice,
                    carts: carts,
                    context: context))
          ]);

  @override
  Widget build(var context) {
    Map states = {'skip': false, 'query': ''};
    return StatefulBuilder(builder: (context, setState) {
      // updateState(map) {
      //   map is Map
      //       ? setState(() {
      //           states.addAll(map);
      //         })
      //       : null;
      // }
      var updateState = ifDoElse((x) => x is Map, (x) =>
          setState(() => states.addAll(x)), (x) => null);
      return responsiveBody(
        menus: moduleMenus(),
        office: 'Menu',
        current: backLink,
        rightDrawer: _hasCarts(states)
            ? SizedBox(
                width: 350,
                child: _cartDrawer(
                    states, updateState, context, wholesale, (a) {}))
            : null,
        onBody: (drawer) => Scaffold(
          appBar: states['hab'] == true ? null : _appBar(updateState),
          floatingActionButton: _fab(states, updateState),
          body: FutureBuilder<List>(
            initialData: _getCarts(states),
            future: _future(states),
            builder: _getView(
              _getCarts(states),
              _onAddToCart(states, updateState),
              onAddToCartView,
              _onShowCheckoutSheet(states, updateState, context),
              onGetPrice,
            ),
          ),
        ),
      );
    });
  }

  _cartDrawer(states, updateState, context, wholesale, refresh) => cartDrawer(
        customerLikeLabel: customerLikeLabel,
        onAddItem: (id, q) {
          var addCart = _prepareAddCartQuantity(states, updateState);
          addCart(id, q);
          refresh(() {});
        },
        onRemoveItem: (id) {
          var remove = _prepareRemoveCart(states, updateState);
          remove(id);
          refresh(() {});
        },
        onCheckout: (discount) {
          var customer = '${states['customer'] ?? ''}';
          var carts = states['carts'];
          return onSubmitCart(carts, customer, discount).then((value) {
            updateState({'carts': [], 'customer': ''});
            navigator().maybePop().whenComplete(() {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                      title: const Text('Info',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                      content: Text(checkoutCompleteMessage)));
            });
          }).catchError(_showCheckoutError(context));
          // onCheckout
        },
        carts: _getCarts(states),
        wholesale: wholesale,
        context: context,
        customer: _getCustomer(states),
        onCustomerLikeList: onCustomerLikeList,
        onCustomerLikeAddWidget: onCustomerLikeAddWidget,
        onCustomer: (d) => updateState({"customer": d}),
        onGetPrice: onGetPrice,
      );

  _prepareRemoveCart(states, updateState) => (String id) =>
      updateState({'carts': removeCart(id, states['carts'] ?? [])});

  _prepareAddCartQuantity(states, updateState) => (String id, dynamic q) =>
      updateState({'carts': updateCartQuantity(id, q, states['carts'] ?? [])});

  _showCheckoutError(context) => (error) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 200, maxHeight: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Error',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                    Expanded(
                        child: SingleChildScrollView(child: Text('$error'))),
                  ],
                ),
              ),
            ),
          ),
        );
      };
}
