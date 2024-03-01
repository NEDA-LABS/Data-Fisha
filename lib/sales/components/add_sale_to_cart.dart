import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/sales/models/cart.model.dart';

class AddSale2CartDialogContent extends StatefulWidget {
  final CartModel cart;
  final OnAddToCartSubmitCallback onAddToCartSubmitCallback;
  final OnGetPrice onGetRetailPrice;
  final OnGetPrice onGetWholesalePrice;

  const AddSale2CartDialogContent({
    required this.cart,
    required this.onAddToCartSubmitCallback,
    required this.onGetRetailPrice,
    required this.onGetWholesalePrice,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddSale2CartDialogContent> {
  Map? _product = {};
  String _name = '';
  dynamic _quantity = '';
  dynamic _retailPrice = '';
  dynamic _wholesalePrice = '';
  Map _errors = {};
  Map _shop = {};
  bool _isQuickSale = false;
  String _selectedPrice = 'retail';

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
    _updateState(() {
      _isQuickSale = doubleOrZero(widget.cart.product['id']) == 0;
      _product = widget.cart.product;
      _name = widget.cart.product['product'] ?? '';
      _quantity = widget.cart.quantity;
      _retailPrice = doubleOrZero('${widget.cart.product['retailPrice']}');
      _wholesalePrice =
          doubleOrZero('${widget.cart.product['wholesalePrice']}');
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
        const WhiteSpacer(height: 16),
        const LabelLarge(text: 'SELECT PRICE'),
        _getPrices(),
        const WhiteSpacer(height: 8),
        const WhiteSpacer(height: 16),
        const LabelLarge(text: 'SUB TOTAL'),
        BodyLarge(text: '${_shop['settings']?['currency']??''} ${_getSubTotal()}'),
      ],
    );
    return Container(
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
          widget.onAddToCartSubmitCallback(_getSaleCart());
        }
      },
    );
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16), child: buttons);
  }

  _getSaleCart() {
    Map product = _product is Map && _product?['id'] != null
        ? (_product as Map<String, dynamic>?)!
        : {'id': _name, '_type': 'quick', 'product': _name};
    product["retailPrice"] = _retailPrice;
    product["wholesalePrice"] = _wholesalePrice;
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
    if (_retailPrice == 0) {
      _errors['retailPrice'] = 'Sale price required, must be greater than zero';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }

  _getPrices() {
    if (_isQuickSale) {
      return TextInput(
          label:
              "Sale price ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Item",
          initialText: '$_retailPrice',
          lines: 1,
          error: '${_errors['retailPrice'] ?? ''}',
          type: TextInputType.number,
          onText: (v) {
            _updateState(() {
              _retailPrice = doubleOrZero(v);
              _errors = {..._errors, 'retailPrice': ''};
            });
          });
    } else {
      var currency = _shop['settings']?['currency'] ?? 'TZS';
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          {"value": _retailPrice, 'id': 'Sale price ( $currency ) / Item'},
          {
            'value': _wholesalePrice,
            'id': 'Wholesale price ( $currency ) / Item'
          }
        ].map((e) {
          return Expanded(
            child: TextInput(
              label: e['id'],
              initialText: '${e['value']}',
              readOnly: true,
              type: TextInputType.number,
              onText: (v) {},
            ),
          );
        }).toList(),
      );
    }
  }

  _getSubTotal() {

  }
}
