import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/cart_drawer.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/refresh_button.dart';
import 'package:smartstock/core/components/SalesLikeBody.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/services/api_shop.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/location.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/types/OnAddToCartView.dart';
import 'package:smartstock/core/types/OnCheckout.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/core/types/OnGetProductsLike.dart';
import 'package:smartstock/sales/models/cart.model.dart';

class SaleLikePage extends StatefulWidget {
  final String title;
  final bool wholesale;
  final OnGetPrice onGetPrice;
  final OnAddToCart onAddToCart;
  final OnCheckout onCheckout;
  final TextEditingController? searchTextController;
  final OnGetProductsLike onGetProductsLike;
  final VoidCallback? onBack;

  const SaleLikePage({
    required this.title,
    required this.wholesale,
    required this.onCheckout,
    required this.onGetPrice,
    required this.onAddToCart,
    this.onBack,
    this.searchTextController,
    required this.onGetProductsLike,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleLikePage> {
  final Map _states = {'skip': false, 'query': ''};
  final _getSkip = propertyOr('skip', (p0) => false);
  final _getQuery = propertyOr('query', (p0) => '');

  StreamSubscription<Position>? _locationSubscriptionStream;

  @override
  void initState() {
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
    });
    super.initState();
  }

  @override
  Widget build(var context) {
    return ResponsivePage(
      office: 'Menu',
      rightDrawer: _hasCarts(_states)
          ? SizedBox(width: 350, child: _cartDrawer((p0) {}))
          : null,
      onBody: (drawer) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _states['hab'] == true ? Container() : _appBar(_updateState)
            ];
          },
          body: Scaffold(
            floatingActionButton: _fab(),
            body: FutureBuilder<List>(future: _future(), builder: _getView),
          ),
        );
      },
    );
  }

  List<CartModel> _getCarts(Map data) {
    List<CartModel> carts = itOrEmptyArray(data['carts']);
    return carts;
  }

  _updateState(Map data) {
    if (mounted) {
      setState(() {
        _states.addAll(data);
      });
    }
  }

  _hasCarts(states) => _getCarts(states).isNotEmpty;

  _future() {
    return widget.onGetProductsLike(
        skipLocal: _getSkip(_states), stringLike: _getQuery(_states));
  }

  _onAddToCart(CartModel cart) {
    List<CartModel> carts = appendToCarts(cart, _getCarts(_states));
    _updateState({"carts": carts, 'query': ''});
    Navigator.of(context).maybePop();
  }

  _onShowCartSheet() {
    showFullScreeDialog(context, (refresh) => _cartDrawer(refresh));
  }

  _appBar(updateState) {
    return SliverSmartStockAppBar(
      title: widget.title,
      searchTextController: widget.searchTextController,
      showBack: true,
      showSearch: true,
      searchHint: "Search here...",
      onBack: widget.onBack,
      onSearch: (text) {
        if (text.startsWith('qr_code:')) {
          var barCodeQ = text.replaceFirst('qr_code:', '');
          widget
              .onGetProductsLike(skipLocal: false, stringLike: barCodeQ)
              .then((value) {
            Map? inventory = itOrEmptyArray(value).firstWhere((element) {
              var getBarCode = propertyOrNull('barcode');
              var barCode = getBarCode(element);
              return barCode == barCodeQ && barCodeQ != '' && barCodeQ != '_';
            }, orElse: () => null);
            if (inventory != null) {
              widget.onAddToCart(inventory, _onAddToCart);
            }
          }).catchError((e) {});
        } else {
          updateState({"query": text, 'skip': false});
        }
      },
      context: context,
    );
  }

  _fab() {
    return salesRefreshButton(
      onPressed: () => _updateState({"skip": true, 'query': ''}),
      carts: _states['carts'] ?? [],
      context: context,
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
            ? BodyLarge(text: "${snapshot.error}")
            : Container(),
        Expanded(
          child: SalesLikeBody(
            onAddToCart: _onAddToCart,
            wholesale: widget.wholesale,
            products: snapshot.data ?? [],
            onAddToCartView: widget.onAddToCart,
            onShowCart: _onShowCartSheet,
            onGetPrice: widget.onGetPrice,
            carts: _getCarts(_states),
          ),
        )
      ],
    );
  }

  _cartDrawer(void Function(VoidCallback) refresh) {
    return CartDrawer(
      // showCustomerLike: widget.showCustomerLike,
      // customerLikeLabel: widget.customerLikeLabel,
      onAddItem: (id, q) {
        var addCart = _prepareAddCartQuantity(_states, _updateState);
        addCart(id, q);
        refresh(() {});
      },
      onRemoveItem: (id) {
        var remove = _prepareRemoveCart(_states, _updateState);
        remove(id);
        var has = _hasCarts(_states);
        if (has == true) {
          refresh(() {});
        } else {
          if (!hasEnoughWidth(context)) {
            Navigator.of(context).maybePop();
          }
        }
      },
      onCartCheckout: () {
        // Map customer = states['customer'] is Map ? states['customer'] : {};
        // var carts = states['carts'];
        // return widget.onSubmitCart(carts, customer, discount).then((value) {
        // updateState({'carts': [], 'customer': ''});
        // Navigator.of(context).maybePop().whenComplete(() {
        //   showInfoDialog(context, widget.checkoutCompleteMessage);
        // });
        // }).catchError(_showCheckoutError(context));
        widget.onCheckout(
            _states['carts'] is List<CartModel> ? _states['carts'] : []);
      },
      carts: _getCarts(_states),
      // showDiscountView: widget.showDiscountView,
      wholesale: widget.wholesale,
      // customer: _getCustomer(states),
      // onCustomerLikeList: widget.onCustomerLikeList,
      // onCustomerLikeAddWidget: widget.onCustomerLikeAddWidget,
      // onCustomer: (d) => updateState({"customer": d}),
      onGetPrice: widget.onGetPrice,
    );
  }

  _prepareRemoveCart(states, updateState) {
    return (String id) =>
        updateState({'carts': removeCart(id, states['carts'] ?? [])});
  }

  _prepareAddCartQuantity(states, updateState) {
    return (String id, dynamic q) => updateState(
        {'carts': updateCartQuantity(id, q, states['carts'] ?? [])});
  }

  // _showCheckoutError(context) {
  //   return (error) {
  //     showInfoDialog(context, error);
  //   };
  // }

  @override
  void dispose() {
    if (_locationSubscriptionStream != null) {
      _locationSubscriptionStream?.cancel();
    }
    super.dispose();
  }
}
