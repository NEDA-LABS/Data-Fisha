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
  dynamic _wholesalePrice = '';
  String _expire = '';
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
      _updateState(() {
        _shop = value;
      });
    }).catchError((e) {});
    var exp = _getFromCartProduct(widget.cart, 'expire', '');
    _updateState(() {
      _canExpire =  exp != '' && exp != null;
      _product = widget.cart.product;
      _name = widget.cart.product['product'] ?? '';
      _quantity = widget.cart.quantity;
      _purchase = doubleOrZero('${widget.cart.product['purchase']}');
      _retailPrice = doubleOrZero('${widget.cart.product['retailPrice']}');
      _wholesalePrice = doubleOrZero('${widget.cart.product['wholesalePrice']}');
      _expire = widget.cart.product['expire'] ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var list = ListView(
      shrinkWrap: true,
      children: <Widget>[
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
                "Retail price ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Item",
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
        TextInput(
            label:
                "Wholesale price ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Item",
            initialText: '$_wholesalePrice',
            lines: 1,
            error: '${_errors['wholesalePrice'] ?? ''}',
            type: TextInputType.number,
            onText: (v) {
              _updateState(() {
                _wholesalePrice = doubleOrZero(v);
                _errors = {..._errors, 'wholesalePrice': ''};
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
    var mainView = Column(
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
    );
    return Container(
      // decoration: _addToCartBoxDecoration(),
      constraints: isSmallScreen ? null : const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: isSmallScreen? mainView: SingleChildScrollView(child: mainView),
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
        : {'id': _name, '__type': 'quick', 'product': _name};
    product["purchase"] = _purchase;
    product["retailPrice"] = _retailPrice;
    product["wholesalePrice"] = _wholesalePrice;
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
          'Purchase price required, must be greater than zero and less than sale price';
      hasError = false;
    }
    if (_retailPrice == 0 || _retailPrice <= _purchase) {
      _errors['retailPrice'] =
          'Sale price required, must be greater than zero and purchase price';
      hasError = false;
    }
    if (_wholesalePrice == 0 || _wholesalePrice <= _purchase) {
      _errors['wholesalePrice'] =
      'Wholesale price required, must be greater than zero and purchase price';
      hasError = false;
    }
    if (_canExpire == true && _expire == '') {
      _errors['expire'] = 'Expire date required';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }
}
