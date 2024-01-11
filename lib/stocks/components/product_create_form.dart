import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CardRoot.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/components/with_active_shop.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/ProductDescriptionInput.dart';
import 'package:smartstock/stocks/components/ProductNameInput.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductCreateForm extends StatefulWidget {
  final InventoryType inventoryType;
  final OnBackPage onBackPage;

  const ProductCreateForm({
    Key? key,
    required this.inventoryType,
    required this.onBackPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductCreateForm> {
  Map<String, dynamic> product = {};
  Map<String, dynamic> error = {};
  List<FileData?> _fileData = [];
  List _categories = [];
  var loading = false;

  clearFormState() {
    product = {};
  }

  updateFormState(Map<String, dynamic> data) {
    product.addAll(data);
  }

  refresh() => setState(() {});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WithActiveShop(onChild: (shop) {
      var isSmallScreen = getIsSmallScreen(context);
      if (isSmallScreen) {
        return _getSmallScreenView(shop);
      } else {
        return _getLargeScreenView(shop);
      }
    });
  }

  Widget _getDescriptionInput() {
    return ProductDescriptionInput(
      onText: (d) => updateFormState({"description": d}),
      error: error['description'] ?? '',
    );
  }

  Widget _getProductNameInput() {
    return ProductNameInput(
      onText: (d) => updateFormState({"product": d}),
      // text: product['product'] ?? '',
      error: error['product'] ?? '',
    );
  }

  Widget _getCategoryInput() {
    return ChoicesInput(
      multiple: true,
      choice: _categories,
      onChoice: (d) {
        _categories = itOrEmptyArray(d);
        updateFormState(
            {"category": _categories.map((e) => e['name']).join(',')});
        // d['name']??''
        refresh();
      },
      label: "Categories",
      placeholder: '',
      error: error['category'] ?? '',
      getAddWidget: () => const CreateCategoryContent(),
      onField: (x) => '${x['name']}',
      onLoad: getCategoryFromCacheOrRemote,
    );
  }

  Widget _barcodeInput() {
    return TextInput(
      onText: (d) => updateFormState({"barcode": d}),
      label: "Barcode / Qrcode",
      placeholder: "Optional",
      error: error['barcode'] ?? '',
      value: '${product['barcode'] ?? ''}',
      initialText: '${product['barcode'] ?? ''}',
      icon: mobileQrScanIconButton(context, (code) {
        updateFormState({"barcode": '$code'});
        refresh();
      }),
    );
  }

  Widget _imagesInput() {
    // return Container();
    return FileSelect(
      files: _fileData,
      onFile: (file) {
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
                              "Recommended ration 1:1",
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
      label: "Price ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
      placeholder: "",
      error: error['retailPrice'] ?? '',
      initialText: '${product['retailPrice'] ?? ''}',
      type: TextInputType.number,
    );
  }

  // Widget _wholesalePriceInput(Map shop) {
  //   return TextInput(
  //     onText: (d) => updateFormState({"wholesalePrice": d}),
  //     label:
  //         "Wholesale price ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
  //     placeholder: "",
  //     error: error['wholesalePrice'] ?? '',
  //     initialText: '${product['wholesalePrice'] ?? ''}',
  //     type: TextInputType.number,
  //   );
  // }

  Widget _costPriceInput(Map shop) {
    return TextInput(
      onText: (d) => updateFormState({"purchase": d}),
      label: "Cost ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
      placeholder: "",
      error: error['purchase'] ?? '',
      initialText: '${product['purchase'] ?? ''}',
      type: TextInputType.number,
    );
  }

  Widget _quantityInput() {
    return TextInput(
      onText: (d) => updateFormState({"quantity": d}),
      label: "Quantity",
      placeholder: "Current stock quantity",
      error: error['quantity'] ?? '',
      initialText: '${product['quantity'] ?? ''}',
      type: TextInputType.number,
    );
  }

  Widget _expireInput() {
    return DateInput(
      onText: (d) => updateFormState({"expire": d}),
      label: "Expire",
      placeholder: "YYYY-MM-DD ( Optional )",
      error: error['expire'] ?? '',
      initialText: product['expire'] ?? '',
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 360 * 100)),
      // type: TextInputType.datetime,
    );
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: loading ? null : _createProduct,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
        // overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
        foregroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      ),
      child: BodyLarge(
        text: loading ? "Waiting..." : "Continue",
      ),
    );
  }

  Widget _getLargeScreenView(Map shop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardRoot(
          child: Row(
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
        ),
        const WhiteSpacer(height: 16),
        CardRoot(child: _imagesInput()),
        const WhiteSpacer(height: 16),
        CardRoot(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: _priceInput(shop)),
                  const WhiteSpacer(width: 8),
                  Expanded(flex: 1, child: _costPriceInput(shop))
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
        ),
        const WhiteSpacer(height: 16),
        CardRoot(child: _getDescriptionInput()),
        const WhiteSpacer(height: 16),
        CardRoot(
          child: Column(
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
        ),
        const WhiteSpacer(height: 16),
        Container(
          height: 80,
          // width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(minWidth: 200),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: _submitButton(),
        )
      ],
    );
  }

  Widget _getSmallScreenView(Map shop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardRoot(
          child: Row(
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
        ),
        const WhiteSpacer(height: 16),
        CardRoot(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _priceInput(shop),
              // _wholesalePriceInput(shop),
              const WhiteSpacer(height: 8),
              _costPriceInput(shop)
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        CardRoot(child: _getDescriptionInput()),
        const WhiteSpacer(height: 16),
        CardRoot(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_quantityInput(), _expireInput()],
          ),
        ),
        const WhiteSpacer(height: 16),
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(minWidth: 200),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: _submitButton(),
        )
      ],
    );
  }

  _createProduct() {
    setState(() {
      error = {};
      loading = true;
    });
    createOrUpdateProduct(
      context,
      error,
      loading,
      false,
      {
        ...product,
        'stockable': true,
        'saleable': true,
        'purchasable': true,
        'supplier': 'general',
        'wholesalePrice': product['wholesalePrice'] ?? product['retailPrice']
      },
      _fileData,
    ).then((value) => widget.onBackPage()).catchError((error) {
      showInfoDialog(context, error);
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
