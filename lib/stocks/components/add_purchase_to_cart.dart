import 'package:flutter/material.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/ProductExpireInput.dart';

// void addPurchaseToCartView({
//   required BuildContext context,
//   required CartModel cart,
//   required onAddToCart,
//   required onGetPrice,
// }) {
//
// }

class AddPurchase2CartDialogContent extends StatefulWidget {
  final CartModel cart;
  final OnAddToCartSubmitCallback onAddToCartSubmitCallback;
  final OnGetPrice onGetPrice;

  const AddPurchase2CartDialogContent({
    required this.cart,
    required this.onAddToCartSubmitCallback,
    required this.onGetPrice,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddPurchase2CartDialogContent> {
  Map? _product = {};
  String _name = '';
  dynamic _quantity = '';
  dynamic _purchase = '';
  dynamic _retailPrice = '';
  String _expire = '';

  // Map _states = {};
  Map _errors = {};
  Map _shop = {};
  bool _canExpire = false;

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void initState() {
    getActiveShop().then((value) {
      setState(() {
        _shop = value;
      });
    }).catchError((e) {});
    _canExpire = _getFromCartProduct(widget.cart, 'expire', '') != '';
    _product = widget.cart.product;
    _name = widget.cart.product['product'] ?? '';
    _quantity = widget.cart.quantity;
    _purchase = doubleOrZero('${widget.cart.product['purchase']}');
    _retailPrice = doubleOrZero('${widget.cart.product['retailPrice']}');
    _expire = widget.cart.product['expire'] ?? '';
    // _states = {
    // 'purchase': _getFromCartProduct(widget.cart, 'purchase', ''),
    // 'retailPrice': _getFromCartProduct(widget.cart, 'retailPrice', ''),
    // 'wholesalePrice': _getFromCartProduct(widget.cart, 'wholesalePrice',''),
    // 'expire': _getFromCartProduct(widget.cart, 'expire', ''),
    // };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var list = ListView(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      shrinkWrap: true,
      children: <Widget>[
        // _productAndPrice(_states['p'], widget.onGetPrice),
        TextInput(
            label: 'Item',
            initialText: _name,
            lines: 1,
            error: '${_errors['name'] ?? ''}',
            type: TextInputType.text,
            readOnly: _product?['id'] != null,
            onText: (v) {
              _updateState(() {
                _name = v;
                _errors = {..._errors, 'name': ''};
              });
            }),
        TextInput(
            label: 'Quantity',
            initialText: '$_quantity',
            lines: 1,
            error: '${_errors['q'] ?? ''}',
            type: TextInputType.number,
            onText: (v) {
              _updateState(() {
                _quantity = doubleOrZero(v);
                _errors = {..._errors, 'quantity': ''};
              });
            }),
        TextInput(
            label:
                'Purchase cost ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Item',
            initialText: '$_purchase',
            lines: 1,
            error: '${_errors['purchase'] ?? ''}',
            type: TextInputType.number,
            onText: (v) {
              _updateState(() {
                _purchase = doubleOrZero(v);
                _errors = {..._errors, 'purchase': ''};
              });
            }),
        TextInput(
            label:
                "Sell price ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Item",
            initialText: '$_retailPrice',
            lines: 1,
            error: '${_errors['retailPrice'] ?? ''}',
            type: TextInputType.number,
            onText: (v) {
              _updateState(() {
                _retailPrice = doubleOrZero(v);
                _errors = {..._errors, 'retailPrice': ''};
              });
            }),
        ProductExpireInput(
          onCanExpire: (value) {
            _canExpire = value;
          },
          onDate: (d) {
            _updateState(() {
              _expire = d;
              _errors = {..._errors, 'expire': ''};
            });
          },
          trackExpire: _canExpire,
          error: _errors['expire'] ?? '',
          date: _expire,
        ),
      ],
    );
    return Container(
      // decoration: _addToCartBoxDecoration(),
      constraints: isSmallScreen ? null : const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: isSmallScreen ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WhiteSpacer(height: 16),
          const TitleLarge(text: "Add to cart"),
          // const HorizontalLine(),
          isSmallScreen ? Expanded(child: list) : list,
          // const HorizontalLine(),
          const WhiteSpacer(height: 16),
          _getFooterSection()
        ],
      ),
    );
  }

  _getFooterSection() {
    var buttons = CancelProcessButtonsRow(
      cancelText: "Cancel",
      proceedText: "Add",
      onCancel: () => Navigator.of(context).maybePop(),
      onProceed: () {
        var valid = _validateForm();
        if (valid == true) {
          widget.onAddToCartSubmitCallback(_getPurchaseCart());
        }
      },
    );
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16), child: buttons);
  }

  _getFromCartProduct(CartModel cart, String property, [def = 0]) {
    var safePrice = compose([
      propertyOr(property, (p0) => def),
      propertyOr('product', (p0) => {}),
      (x) => cart.toJSON()
    ]);
    return safePrice(cart);
  }

  // _addToCartButton(context, states, onAddToCart) => Container(
  //       margin: const EdgeInsets.symmetric(vertical: 15),
  //       height: 40,
  //       width: MediaQuery.of(context).size.width,
  //       child: TextButton(
  //         onPressed: () => onAddToCart(_getPurchaseCart(states)),
  //         // style: _addToCartButtonStyle(context),
  //         child: const BodyMedium(text: "ADD TO CART"),
  //       ),
  //     );

  _getPurchaseCart() {
    Map product = _product is Map && _product?['id'] != null
        ? (_product as Map<String, dynamic>?)!
        : {'id': _name, '_type': 'quick', 'product': _name};
    product["purchase"] = _purchase;
    product["retailPrice"] = _retailPrice;
    product["wholesalePrice"] = _retailPrice;
    product["expire"] = _canExpire ? _expire : '';
    return CartModel(product: product, quantity: _quantity);
  }

  _validateForm() {
    _updateState(() {
      _errors = {};
    });
    var hasError = true;
    if (_name == '') {
      _errors['name'] = 'Item name required';
      hasError = false;
    }
    if (_quantity == 0) {
      _errors['q'] = 'Quantity required, must be greater than zero';
      hasError = false;
    }
    // var purchasePrice = doubleOrZero('${_states['purchase']}');
    // var sellPrice = doubleOrZero('${_states['retailPrice']}');
    if (_purchase == 0 || _purchase >= _retailPrice) {
      _errors['purchase'] =
          'Purchase price required, must be greater than zero and less than sell price';
      hasError = false;
    }
    if (_retailPrice == 0 || _retailPrice <= _purchase) {
      _errors['retailPrice'] =
          'Sell price required, must be greater than zero and purchase price';
      hasError = false;
    }
    if (_canExpire == true && _expire == '') {
      _errors['expire'] = 'Expire date required';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }

// _addToCartButtonStyle(context) => ButtonStyle(
//     backgroundColor:
//         MaterialStateProperty.all(Theme.of(context).primaryColorDark));

// _productAndPrice(Map<String, dynamic> product, onGetPrice) {
//   return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
//       child: Column(children: <Widget>[
//         BodyLarge(text: product["product"]),
//         // _amountWidget(product, onGetPrice)
//       ]));
// }

// _amountWidget(product, onGetPrice) => Container(
//     padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//     child: Text('TZS ${onGetPrice(product)}',
//         //formattedAmount(product, wholesale),
//         style: const TextStyle(
//             // color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 17)));

// _addToCartBoxDecoration() => const BoxDecoration(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30),
//         topRight: Radius.circular(30),
//       ),
//     );
}
