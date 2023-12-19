import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/components/with_active_shop.dart';
import 'package:smartstock/core/services/custom_text_editing_controller.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/helpers/markdown_map.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';

import '../../core/models/file_data.dart';

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
  FileData? _fileData;
  var loading = false;
  CustomTextEditingController? _editTextAreaController;

  clearFormState() {
    product = {};
  }

  updateFormState(Map<String, dynamic> data) {
    product.addAll(data);
  }

  refresh() => setState(() {});

  @override
  void initState() {
    _editTextAreaController =
        CustomTextEditingController(textEditorMarkdownMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WithActiveShop(onChild: (shop) {
      var isSmallScreen = getIsSmallScreen(context);
      if (isSmallScreen) {
        return _smallScreenView(shop);
      } else {
        return _largeScreenView(shop);
      }
    });
  }

  Widget _descriptionInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BodyLarge(text: "Description ( Optional )"),
        TextInput(
          lines: 6,
          type: TextInputType.multiline,
          controller: _editTextAreaController,
          onText: (d) {
            updateFormState({"description": d});
          },
          label: "Decorate with *bold*, ~strike~, _italic_",
          error: error['description'] ?? '',
        ),
      ],
    );
  }

  Widget _productNameInput() {
    return TextInput(
      onText: (d) {
        // error['product']='';
        updateFormState({"product": d});
      },
      label: "Name",
      placeholder: 'Brand + generic name',
      error: error['product'] ?? '',
      initialText: product['product'] ?? '',
    );
  }

  Widget _categoryInput() {
    return ChoicesInput(
      onText: (d) {
        updateFormState({"category": d});
        refresh();
      },
      label: "Category",
      placeholder: 'Select category',
      error: error['category'] ?? '',
      initialText: product['category'] ?? '',
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
    return FileSelect(
      onFile: (file) {
        _fileData = file;
      },
      builder: (isEmpty, onPress) {
        return InkWell(
          onTap: onPress,
          child:
          // isEmpty
          //     ?
          LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                        height: 100,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 36),
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background,
                              width: 1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_outlined),
                            WhiteSpacer(width: 16),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyLarge(text: "Click to select image"),
                                WhiteSpacer(height: 6),
                                LabelLarge(
                                    text: "File should not exceed 2MB."
                                        " Recommended ration 1:1",
                                  color: Colors.grey,
                                ),
                              ],
                            )
                          ],
                        ));
                  },
                )
              // : Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //     child: LabelLarge(
              //       text: 'Change image',
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //   ),
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

  Widget _wholesalePriceInput(Map shop) {
    return TextInput(
      onText: (d) => updateFormState({"wholesalePrice": d}),
      label:
          "Wholesale price ( ${shop['settings']?['currency'] ?? 'TZS'} ) / Item",
      placeholder: "",
      error: error['wholesalePrice'] ?? '',
      initialText: '${product['wholesalePrice'] ?? ''}',
      type: TextInputType.number,
    );
  }

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

  Widget _section({required Widget child}) {
    var decoration = BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8));
    var padding = const EdgeInsets.all(16);
    return Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }

  Widget _largeScreenView(Map shop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 4,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_productNameInput(), _categoryInput()])),
              const WhiteSpacer(width: 8),
              Expanded(flex: 2, child: _barcodeInput())
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        _section(child: _imagesInput()),
        const WhiteSpacer(height: 16),
        _section(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: _priceInput(shop)),
                  const WhiteSpacer(width: 8),
                  Expanded(flex: 1, child: _wholesalePriceInput(shop))
                ],
              ),
              const WhiteSpacer(height: 8),
              Row(
                children: [
                  Expanded(flex: 1, child: _costPriceInput(shop)),
                  const WhiteSpacer(width: 8),
                  Expanded(flex: 1, child: Container())
                ],
              )
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        _section(child: _descriptionInput()),
        const WhiteSpacer(height: 16),
        _section(
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

  Widget _smallScreenView(Map shop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _productNameInput(),
                    const WhiteSpacer(height: 8),
                    _barcodeInput(),
                    const WhiteSpacer(height: 8),
                    _categoryInput(),
                    const WhiteSpacer(height: 16),
                    _imagesInput()
                  ],
                ),
              )
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        _section(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _priceInput(shop),
              _wholesalePriceInput(shop),
              const WhiteSpacer(height: 8),
              _costPriceInput(shop)
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        _section(child: _descriptionInput()),
        const WhiteSpacer(height: 16),
        _section(
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
              // 'retailPrice': product['retailPrice'],
              'wholesalePrice':
                  product['wholesalePrice'] ?? product['retailPrice']
            },
            _fileData)
        .then((value) {
      widget.onBackPage();
    }).catchError((error) {
      showInfoDialog(context, error);
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
