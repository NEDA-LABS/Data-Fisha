import 'package:flutter/material.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';

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
  Map _category = {};
  Map _errors = {};
  Map _shop = {};
  TextEditingController _quantityTextController = TextEditingController();
  TextEditingController _purchaseTextController = TextEditingController();
  dynamic _quantity = '';
  dynamic _purchase = '';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var list = ListView(
      shrinkWrap: true,
      children: <Widget>[
        ChoicesInput(
          getAddWidget: () {
            return CreateCategoryContent(
              onNewCategory: (category) {
                setState(() {
                  _category = category;
                });
              },
            );
          },
          onChoice: (p0) {
            _updateState(() {
              _category = p0;
              _errors = {..._errors, 'name': ''};
            });
          },
          choice: _category,
          onLoad: getCategoryFromCacheOrRemote,
          onField: (p0) {
            return p0 is Map ? p0['name'] ?? '' : '';
          },
          error: '${_errors['name'] ?? ''}',
          label: 'Waste category',
        ),
        TextInput(
            label: 'Kilogram',
            controller: _quantityTextController,
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
            label: 'Cost ( ${_shop['settings']?['currency'] ?? 'TZS'} ) / Kg',
            lines: 1,
            controller: _purchaseTextController,
            error: '${_errors['purchase'] ?? ''}',
            type: TextInputType.number,
            onText: (v) {
              _updateState(() {
                _purchase = doubleOrZero(v);
                _errors = {..._errors, 'purchase': ''};
              });
            }),
        const WhiteSpacer(height: 16),
        const LabelMedium(text: 'SUB TOTAL'),
        const WhiteSpacer(height: 8),
        TitleLarge(
            text:
                '${_shop['settings']?['currency'] ?? 'TZS'} ${formatNumber(doubleOrZero(_quantity) * doubleOrZero(_purchase))}'),
        const WhiteSpacer(height: 16)
      ],
    );
    var mainView = Column(
      mainAxisSize: isSmallScreen ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WhiteSpacer(height: 16),
        list,
        const WhiteSpacer(height: 16),
        _getFooterSection()
      ],
    );
    return Container(
      constraints: isSmallScreen ? null : const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: isSmallScreen ? mainView : SingleChildScrollView(child: mainView),
    );
  }

  _getFooterSection() {
    var buttons = CancelProcessButtonsRow(
      cancelText: "Clear",
      proceedText: "Add",
      onCancel: _clearForm,
      onProceed: () {
        var valid = _validateForm();
        if (valid == true) {
          widget.onAddToCartSubmitCallback(_getPurchaseCart());
          _clearForm();
        }
      },
    );
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16), child: buttons);
  }

  _getPurchaseCart() {
    Map product = {
      'id': _category['name'],
      '__type': 'quick',
      'product': _category['name']
    };
    product["purchase"] = doubleOrZero(_purchase);
    product["retailPrice"] = doubleOrZero(_purchase) + 1;
    product["wholesalePrice"] = doubleOrZero(_purchase) + 1;
    return CartModel(product: product, quantity: doubleOrZero(_quantity));
  }

  _validateForm() {
    _updateState(() {
      _errors = {};
    });
    var hasError = true;
    if (_category['name'] == '' || _category['name'] == null) {
      _errors['name'] = 'Waste name required';
      hasError = false;
    }
    if (doubleOrZero(_quantity) == 0) {
      _errors['q'] = 'Quantity required, must be greater than zero';
      hasError = false;
    }
    if (doubleOrZero(_purchase) <= 0) {
      _errors['purchase'] = 'Cost price required, must be greater than zero';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }

  void _clearForm() {
    setState(() {
      _quantityTextController = TextEditingController();
      _purchaseTextController = TextEditingController();
      _category = {};
      _errors = {};
      _quantity = '';
      _purchase = '';
    });
  }
}
