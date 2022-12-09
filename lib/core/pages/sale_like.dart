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

class SaleLikePage extends StatefulWidget {
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
  final bool showCustomerLike;
  final TextEditingController? searchTextController;
  final Future Function({bool skipLocal, String stringLike}) onGetProductsLike;

  const SaleLikePage({
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
    this.searchTextController,
    this.showCustomerLike = true,
    required this.onGetProductsLike,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleLikePage> {
  Map states = {'skip': false, 'query': ''};
  dynamic updateState;
  final _getSkip = propertyOr('skip', (p0) => false);
  final _getQuery = propertyOr('query', (p0) => '');
  final _getCarts = propertyOr('carts', (p0) => []);
  final _getCustomer = propertyOr('customer', (p0) => '');

  @override
  void initState() {
    updateState = ifDoElse(
      (x) => x is Map,
      (x) => setState(() => states.addAll(x)),
      (x) => null,
    );
    super.initState();
  }

  @override
  Widget build(var context) {
    return responsiveBody(
      menus: moduleMenus(),
      office: 'Menu',
      current: widget.backLink,
      rightDrawer: _hasCarts(states)
          ? SizedBox(
              width: 350,
              child: _cartDrawer(
                  states, updateState, context, widget.wholesale, (a) {}))
          : null,
      onBody: (drawer) => Scaffold(
        appBar: states['hab'] == true ? null : _appBar(updateState),
        floatingActionButton: _fab(states, updateState),
        body: FutureBuilder<List>(future: _future(), builder: _getView),
      ),
    );
  }

  _hasCarts(states) => _getCarts(states).length > 0;

  _future() => widget.onGetProductsLike(
      skipLocal: _getSkip(states), stringLike: _getQuery(states));

  _onAddToCart(states, updateState) => (cart) {
        var carts = appendToCarts(cart, _getCarts(states));
        updateState({"carts": carts, 'query': ''});
        navigator().maybePop();
      };

  _onShowCheckoutSheet(states, updateState, context) {
    return () => fullScreeDialog(
          context,
          (refresh) => _cartDrawer(
            states,
            updateState,
            context,
            widget.wholesale,
            refresh,
          ),
        );
  }

  _appBar(updateState) {
    return StockAppBar(
      title: widget.title,
      backLink: widget.backLink,
      searchTextController: widget.searchTextController,
      showBack: true,
      showSearch: true,
      searchHint: "Search here...",
      onSearch: (text) {
        updateState({"query": text ?? '', 'skip': false});
      },
    );
  }

  _fab(states, updateState) {
    return salesRefreshButton(
      onPressed: () => updateState({"skip": true, 'query': ''}),
      carts: states['carts'] ?? [],
    );
  }

  _isLoading(snapshot) =>
      snapshot is AsyncSnapshot &&
      snapshot.connectionState == ConnectionState.waiting;

  Widget _getView(context, snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isLoading(snapshot)
            ? const LinearProgressIndicator()
            : const SizedBox(height: 0),
        snapshot is AsyncSnapshot && snapshot.hasError
            ? Text("${snapshot.error}")
            : Container(),
        Expanded(
          child: salesLikeBody(
            onAddToCart: _onAddToCart(states, updateState),
            wholesale: widget.wholesale,
            products: snapshot.data ?? [],
            onAddToCartView: widget.onAddToCartView,
            onShowCheckout: _onShowCheckoutSheet(states, updateState, context),
            onGetPrice: widget.onGetPrice,
            carts: _getCarts(states),
            context: context,
          ),
        )
      ],
    );
  }

  _cartDrawer(states, updateState, context, wholesale, refresh) {
    return CartDrawer(
      showCustomerLike: widget.showCustomerLike,
      customerLikeLabel: widget.customerLikeLabel,
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
        return widget.onSubmitCart(carts, customer, discount).then((value) {
          updateState({'carts': [], 'customer': ''});
          navigator().maybePop().whenComplete(() {
            showDialog(
                context: context,
                builder: (c) => AlertDialog(
                    title: const Text('Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)),
                    content: Text(widget.checkoutCompleteMessage)));
          });
        }).catchError(_showCheckoutError(context));
        // onCheckout
      },
      carts: _getCarts(states),
      wholesale: wholesale,
      customer: _getCustomer(states),
      onCustomerLikeList: widget.onCustomerLikeList,
      onCustomerLikeAddWidget: widget.onCustomerLikeAddWidget,
      onCustomer: (d) => updateState({"customer": d}),
      onGetPrice: widget.onGetPrice,
    );
  }

  _prepareRemoveCart(states, updateState) {
    return (String id) =>
        updateState({'carts': removeCart(id, states['carts'] ?? [])});
  }

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
