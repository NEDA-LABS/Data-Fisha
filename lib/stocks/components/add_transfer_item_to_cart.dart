import 'package:flutter/material.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/sales/models/cart.model.dart';


class AddTransferItem2Cart extends StatefulWidget {
  final CartModel cart;
  final OnAddToCartSubmitCallback onAddToCartSubmitCallback;
  final OnGetPrice onGetPrice;

  const AddTransferItem2Cart({
    required this.cart,
    required this.onAddToCartSubmitCallback,
    required this.onGetPrice,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddTransferItem2Cart> {
  Map? _product = {};
  String _name = '';
  dynamic _quantity = '';
  dynamic _purchase = '';
  Map _errors = {};
  Map _shop = {};

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
    _product = widget.cart.product;
    _name = widget.cart.product['product'] ?? '';
    _quantity = widget.cart.quantity;
    _purchase = doubleOrZero('${widget.cart.product['purchase']}');
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
            readOnly: true,
            onText: (v) {
              _updateState(() {
                _name = v;
                _errors = {..._errors, 'name': ''};
              });
            }),
        TextInput(
            label:
                'Purchase cost ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Item',
            initialText: '$_purchase',
            lines: 1,
            error: '${_errors['purchase'] ?? ''}',
            type: TextInputType.number,
            readOnly: true,
            onText: (v) {
              // _updateState(() {
              //   _purchase = doubleOrZero(v);
              //   _errors = {..._errors, 'purchase': ''};
              // });
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
          isSmallScreen ? Expanded(child: list) : list,
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
          widget.onAddToCartSubmitCallback(_getItemCart());
        }
      },
    );
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16), child: buttons);
  }

  _getItemCart() {
    Map product = _product is Map && _product?['id'] != null
        ? (_product as Map<String, dynamic>?)!
        : {'id': _name, 'product': _name};
    return CartModel(product: product, quantity: _quantity);
  }

  _validateForm() {
    _updateState(() {
      _errors = {};
    });
    var hasError = true;
    if (_quantity == 0) {
      _errors['q'] = 'Quantity required, must be greater than zero';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }
}
