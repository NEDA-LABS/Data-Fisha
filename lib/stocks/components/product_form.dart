import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/stocks/components/ProductDescriptionInput.dart';
import 'package:smartstock/stocks/components/ProductExpireInput.dart';
import 'package:smartstock/stocks/components/ProductNameInput.dart';
import 'package:smartstock/stocks/components/ProductQuantityInput.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';

typedef OnProductSubmit = Future Function({
  required Map product,
  required Map shop,
  required List<FileData?> files,
});

class ProductForm extends StatefulWidget {
  final Map product;
  final OnProductSubmit onSubmit;

  const ProductForm({
    super.key,
    required this.product,
    required this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductForm> {
  bool _stockable = false;
  bool _canExpire = false;
  Map _product = {};
  Map<String, dynamic> _errors = {};
  List<FileData?> _fileData = [];
  List _categories = [];
  var _loading = false;
  Map _shop = {};

  clearFormState() {
    _product = {};
  }

  updateFormState(Map<String, dynamic> data) {
    _product.addAll(data);
  }

  refresh() => setState(() {});

  @override
  void initState() {
    getActiveShop().then((value) {
      _updateState(() {
        _shop = value;
      });
    });
    _product = {...widget.product};
    _stockable = _product['stockable'] == true;
    _canExpire = '${_product['expire'] ?? ''}'.isNotEmpty;
    _categories = ('${_product['category'] ?? ''}')
        .split(',')
        .where((ex) => ex.isNotEmpty)
        .map((e) => {'name': e})
        .toList();
    _fileData = _getInitialFileData({...widget.product});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    if (isSmallScreen) {
      return _getSmallScreenView(_shop);
    } else {
      return _getLargeScreenView(_shop);
    }
  }

  Widget _getDescriptionInput() {
    return ProductDescriptionInput(
      text: '${_product['description'] ?? ''}',
      onText: (d) => updateFormState({"description": d}),
      error: _errors['description'] ?? '',
    );
  }

  Widget _getProductNameInput() {
    return ProductNameInput(
      text: '${_product['product'] ?? ''}',
      onText: (d) => updateFormState({"product": d}),
      // text: product['product'] ?? '',
      error: _errors['product'] ?? '',
    );
  }

  Widget _getCategoryInput() {
    return ChoicesInput(
      multiple: true,
      choice: _categories,
      comparisonKey: 'name',
      onChoice: (d) {
        _categories = itOrEmptyArray(d);
        updateFormState(
            {"category": _categories.map((e) => e['name']).join(',')});
        refresh();
      },
      label: "Categories",
      placeholder: '',
      error: _errors['category'] ?? '',
      getAddWidget: () => CreateCategoryContent(
        onNewCategory: (category) {
          _categories = [category];
          if (kDebugMode) {
            print(_categories);
          }
          updateFormState(
              {"category": _categories.map((e) => e['name']).join(',')});
          refresh();
        },
      ),
      onField: (x) => '${x['name']}',
      onLoad: getCategoryFromCacheOrRemote,
    );
  }

  Widget _barcodeInput() {
    return TextInput(
      onText: (d) => updateFormState({"barcode": d}),
      label: "Barcode / Qrcode",
      placeholder: "Optional",
      error: _errors['barcode'] ?? '',
      value: '${_product['barcode'] ?? ''}',
      initialText: '${_product['barcode'] ?? ''}',
      icon: mobileQrScanIconButton(context, (code) {
        updateFormState({"barcode": '$code'});
        refresh();
      }),
    );
  }

  Widget _imagesInput() {
    return FileSelect(
      files: _fileData,
      onFiles: (file) {
        _fileData = file;
      },
      builder: (isEmpty, onPress) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: InkWell(
            onTap: onPress,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                    // height: 10,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.background,
                          width: 1),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined),
                        BodyLarge(text: "Click to select image"),
                        WhiteSpacer(height: 6),
                        LabelLarge(
                          textAlign: TextAlign.center,
                          text: "File should not exceed 2MB."
                              " Recommended ration 1:1",
                          color: Colors.grey,
                        ),
                      ],
                    ));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _priceInput(Map shop) {
    return TextInput(
      onText: (d) => updateFormState({"retailPrice": d}),
      label: "Sale price ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
      placeholder: "",
      error: _errors['retailPrice'] ?? '',
      initialText: '${_product['retailPrice'] ?? ''}',
      type: TextInputType.number,
    );
  }

  Widget _wholesalePriceInput(Map shop) {
    return TextInput(
      onText: (d) => updateFormState({"wholesalePrice": d}),
      label:
          "Wholesale price ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
      placeholder: "",
      error: _errors['wholesalePrice'] ?? '',
      initialText: '${_product['wholesalePrice'] ?? ''}',
      type: TextInputType.number,
    );
  }

  Widget _costPriceInput(Map shop) {
    return TextInput(
      onText: (d) => updateFormState({"purchase": d}),
      label:
          "Purchase cost ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
      placeholder: "",
      error: _errors['purchase'] ?? '',
      initialText: '${_product['purchase'] ?? ''}',
      type: TextInputType.number,
    );
  }

  Widget _quantityInput() {
    return ProductQuantityInput(
      onCanTrack: (value) {
        _stockable = value;
      },
      onQuantity: (value) {
        updateFormState({"quantity": value});
      },
      text: '${_product['quantity'] ?? ''}',
      error: _errors['quantity'] ?? '',
      trackQuantity: _stockable,
    );
  }

  Widget _expireInput() {
    return ProductExpireInput(
      onCanExpire: (value) {
        _canExpire = value;
      },
      onDate: (d) => updateFormState({"expire": d}),
      trackExpire: _canExpire,
      error: _errors['expire'] ?? '',
      date: _product['expire'] ?? '',
    );
  }

  Widget _submitButton(Map shop) {
    return TextButton(
      onPressed: _loading ? null : () => _onSubmit(shop),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
        // overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
        foregroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      ),
      child: BodyLarge(text: _loading ? "Waiting..." : "Continue"),
    );
  }

  Widget _getLargeScreenView(Map shop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [_getProductNameInput(), _getCategoryInput()],
              ),
            ),
            const WhiteSpacer(width: 8),
            Expanded(flex: 2, child: _barcodeInput())
          ],
        ),
        const WhiteSpacer(height: 16),
        _imagesInput(),
        const WhiteSpacer(height: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: _costPriceInput(shop)),
                const WhiteSpacer(width: 8),
                Expanded(flex: 1, child: _priceInput(shop)),
                const WhiteSpacer(width: 8),
                Expanded(flex: 1, child: _wholesalePriceInput(shop)),
              ],
            ),
            const WhiteSpacer(height: 8),
            // Row(
            //   children: [
            //     Expanded(flex: 1, child: _costPriceInput(shop)),
            //     const WhiteSpacer(width: 8),
            //     Expanded(flex: 1, child: Container())
            //   ],
            // )
          ],
        ),
        const WhiteSpacer(height: 16),
        _getDescriptionInput(),
        const WhiteSpacer(height: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: _quantityInput()),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Row(
              children: [
                Expanded(flex: 1, child: _expireInput()),
                Expanded(flex: 1, child: Container()),
              ],
            )
          ],
        ),
        const WhiteSpacer(height: 16),
        Container(
          height: 80,
          // width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(minWidth: 200),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: _submitButton(shop),
        )
      ],
    );
  }

  Widget _getSmallScreenView(Map shop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getProductNameInput(),
                  const WhiteSpacer(height: 8),
                  _barcodeInput(),
                  const WhiteSpacer(height: 8),
                  _getCategoryInput(),
                  const WhiteSpacer(height: 16),
                  _imagesInput()
                ],
              ),
            )
          ],
        ),
        const WhiteSpacer(height: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _costPriceInput(shop),
            // _wholesalePriceInput(shop),
            const WhiteSpacer(height: 8),
            _priceInput(shop),
            const WhiteSpacer(height: 8),
            _wholesalePriceInput(shop),
          ],
        ),
        const WhiteSpacer(height: 16),
        _getDescriptionInput(),
        const WhiteSpacer(height: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _quantityInput(),
            const WhiteSpacer(height: 8),
            _expireInput()
          ],
        ),
        const WhiteSpacer(height: 16),
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(minWidth: 200),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: _submitButton(shop),
        )
      ],
    );
  }

  _fieldIsValidString(field, product, error) {
    var valid = ifDoElse(
      (x) => product[x] is String && product[x].isNotEmpty,
      (x) => true,
      (x) {
        error[x] = 'Required';
        return false;
      },
    );
    return valid(field);
  }

  _fieldIsValidNumber(field, product, error) {
    var value = doubleOrZero(
        '${product[field] ?? ''}'.isNotEmpty ? '${product[field]}' : '-1');
    if (value >= 0) {
      return true;
    } else {
      error[field] = 'Required, and must be greater than zero';
      return false;
    }
  }

  _costIsLowePriceValid(product, error) {
    var cost = doubleOrZero('${product?['purchase'] ?? ''}');
    var price = doubleOrZero('${product?['retailPrice'] ?? ''}');
    if (cost < price && '${product?['purchase'] ?? ''}'.isNotEmpty) {
      return true;
    } else {
      error['purchase'] = 'Required, and must be less than sale price';
      return false;
    }
  }

  _wholesalePriceHigherValid(product, error) {
    var cost = doubleOrZero('${product?['purchase'] ?? ''}');
    var price = doubleOrZero('${product?['wholesalePrice'] ?? ''}');
    if(price>0 && price<cost){
      error['wholesalePrice'] = 'Must be greater than purchase cost price';
      return false;
    }
    else {
      return true;
    }
  }

  _onSubmit(Map shop) {
    _updateState(() {
      _errors = {};
    });
    var invalids = [
      _fieldIsValidString('product', _product, _errors),
      _fieldIsValidString('category', _product, _errors),
      _costIsLowePriceValid(_product, _errors),
      _wholesalePriceHigherValid(_product, _errors),
      _fieldIsValidNumber('retailPrice', _product, _errors),
      _stockable != true
          ? true
          : _fieldIsValidNumber('quantity', _product, _errors),
    ].where((element) => element == false);
    if (invalids.isNotEmpty) {
      _updateState(() => null);
      showTransactionCompleteDialog(
          context, "Please, attend all required fields",
          canDismiss: true, title: 'Error');
    } else {
      _updateState(() {
        // _errors = {};
        _loading = true;
      });
      widget.onSubmit(product: {
        ..._product,
        'stockable': _stockable,
        'saleable': true,
        'purchasable': true,
        'expire': _canExpire ? (_product['expire'] ?? '') : '',
        'supplier': 'general',
        'wholesalePrice':
            _product['wholesalePrice'] ?? _product['retailPrice'] ?? '0'
      }, shop: shop, files: _fileData).catchError((error) {
        showTransactionCompleteDialog(context, error,
            canDismiss: true, title: 'Error');
      }).whenComplete(() {
        _updateState(() {
          _loading = false;
        });
      });
    }
  }

  void _updateState(Null Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  List<FileData?> _getInitialFileData(product) {
    return itOrEmptyArray(product?['images']).map((x) {
      String name = x.split('/').last;
      String ext = name.split('.').last;
      return FileData(
          stream: null, extension: ext, size: -1, name: name, path: x);
    }).toList();
  }
}
