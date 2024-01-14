import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/cart_drawer.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/refresh_button.dart';
import 'package:smartstock/core/components/sales_like_body.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/api_shop.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/location.dart';
import 'package:smartstock/core/helpers/util.dart';

class SaleLikePage extends StatefulWidget{
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
  final bool showDiscountView;
  final Function()? onBack;

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
    this.onBack,
    this.customerLikeLabel = 'Choose customer',
    this.searchTextController,
    this.showCustomerLike = true,
    this.showDiscountView = true,
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
  StreamSubscription<Position>? _locationSubscriptionStream;

  @override
  void initState() {
    updateState = ifDoElse(
      (x) => x is Map,
      (x) => setState(() => states.addAll(x)),
      (x) => null,
    );
    _locationSubscriptionStream =
        getLocationChangeStream().listen((Position? position) {
      if (position != null) {
        updateShopLocation(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        ).then((value) {
          if (kDebugMode) {
            print(value);
          }
        }).catchError((error) {
          if (kDebugMode) {
            print(error);
          }
        });
      }
      //
      // // if (kDebugMode) {
      // print(position == null
      //     ? 'Unknown'
      //     : 'Location: ${position.latitude.toString()}, ${position.longitude.toString()}');
      // // }
    });
    super.initState();
  }

  @override
  Widget build(var context) {
    return ResponsivePage(
      office: 'Menu',
      current: widget.backLink,
      rightDrawer: _hasCarts(states)
          ? SizedBox(
              width: 350,
              child: _cartDrawer(
                states,
                updateState,
                context,
                widget.wholesale,
                (a) {},
              ),
            )
          : null,
      sliverAppBar: null,
      onBody: (drawer) => NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [states['hab'] == true ? Container() : _appBar(updateState)];
        },
        body: Scaffold(
          floatingActionButton: _fab(states, updateState),
          body: FutureBuilder<List>(future: _future(), builder: _getView),
        ),
      ),
    );
  }

  _hasCarts(states) => _getCarts(states).length > 0;

  _future() => widget.onGetProductsLike(
      skipLocal: _getSkip(states), stringLike: _getQuery(states));

  _onAddToCart(states, updateState) => (cart) {
        var carts = appendToCarts(cart, _getCarts(states));
        updateState({"carts": carts, 'query': ''});
        Navigator.of(context).maybePop();
      };

  _onShowCheckoutSheet(states, updateState, context) {
    return () => showFullScreeDialog(
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
    return SliverSmartStockAppBar(
      title: widget.title,
      backLink: widget.backLink,
      searchTextController: widget.searchTextController,
      showBack: true,
      showSearch: true,
      searchHint: "Search here...",
      onBack: widget.onBack,
      onSearch: (text) {
        if (text.startsWith('-1:')) {
          var barCodeQ = text.replaceFirst('-1:', '');
          widget
              .onGetProductsLike(skipLocal: false, stringLike: barCodeQ)
              .then((value) {
            var inventory = itOrEmptyArray(value).firstWhere((element) {
              var getBarCode = propertyOrNull('barcode');
              var barCode = getBarCode(element);
              return barCode == barCodeQ && barCodeQ != '' && barCodeQ != '_';
            }, orElse: () => null);
            if (inventory != null) {
              widget.onAddToCartView(
                  inventory, _onAddToCart(states, updateState));
            }
          }).catchError((e) {});
        } else {
          updateState({"query": text, 'skip': false});
        }
      },
      context: context,
    );
  }

  _fab(states, updateState) {
    return salesRefreshButton(
      onPressed: () => updateState({"skip": true, 'query': ''}),
      carts: states['carts'] ?? [],
        context: context
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
          child: SalesLikeBody(
            onAddToCart: _onAddToCart(states, updateState),
            wholesale: widget.wholesale,
            products: snapshot.data ?? [],
            onAddToCartView: widget.onAddToCartView,
            onShowCheckout: _onShowCheckoutSheet(states, updateState, context),
            onGetPrice: widget.onGetPrice,
            carts: _getCarts(states),
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
          Navigator.of(context).maybePop().whenComplete(() {
            showInfoDialog(context, widget.checkoutCompleteMessage);
            // showDialog(
            //   context: context,
            //   builder: (c) => AlertDialog(
            //     title: const Text(
            //       'Info',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 16,
            //       ),
            //     ),
            //     content: Text(widget.checkoutCompleteMessage),
            //     actions: [
            //       TextButton(
            //           onPressed: () => Navigator.of(context).maybePop(),
            //           child: const Text(
            //             'Close',
            //             style: TextStyle(fontSize: 12),
            //           ))
            //     ],
            //   ),
            // );
          });
        }).catchError(_showCheckoutError(context));
        // onCheckout
      },
      carts: _getCarts(states),
      showDiscountView: widget.showDiscountView,
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

  _showCheckoutError(context) => (error) => showInfoDialog(context, error);

  @override
  void dispose() {
    if (_locationSubscriptionStream != null) {
      _locationSubscriptionStream?.cancel();
    }
    super.dispose();
  }
}
