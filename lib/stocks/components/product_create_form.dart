import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ReadBarcodeView.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';
import 'package:smartstock/stocks/services/supplier.dart';

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

  clearFormState() {
    product = {};
  }

  updateFormState(Map<String, dynamic> data) {
    product.addAll(data);
  }

  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    if (isSmallScreen) {
      return _smallScreenView();
    } else {
      return _largeScreenView();
    }
  }

  Widget _descriptionInput(){
    return TextInput(
      lines: 5,
      onText: (d) {
        // error['product']='';
        updateFormState({"description": d});
      },
      label: "Description ( Optional )",
      // placeholder: 'Optional',
      error: error['description'] ?? '',
      initialText: product['description'] ?? '',
    );
  }

  Widget _largeScreenView() {
    var decoration = BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8));
    var padding = const EdgeInsets.all(16);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: padding,
          decoration: decoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInput(
                      onText: (d) {
                        // error['product']='';
                        updateFormState({"product": d});
                      },
                      label: "Name",
                      placeholder: 'Brand + generic name',
                      error: error['product'] ?? '',
                      initialText: product['product'] ?? '',
                    ),
                    TextInput(
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
                    ),
                    // const WhiteSpacer(height: 8),
                    ChoicesInput(
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
                    ),
                    // ChoicesInput(
                    //   onText: (d) {
                    //     updateFormState({"supplier": d});
                    //     refresh();
                    //   },
                    //   label: "Supplier",
                    //   placeholder: 'Select supplier',
                    //   error: error['supplier'] ?? '',
                    //   initialText: product['supplier'] ?? '',
                    //   getAddWidget: () => const CreateSupplierContent(),
                    //   onField: (x) => '${x['name']}',
                    //   onLoad: getSupplierFromCacheOrRemote,
                    // )
                  ],
                ),
              ),
              const WhiteSpacer(width: 8),
              Expanded(
                flex: 2,
                child: FileSelect(
                  onFile: (file) {
                    _fileData = file;
                  },
                  builder: (isEmpty, onPress) {
                    return InkWell(
                      onTap: onPress,
                      child: isEmpty
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                // print(constraints);
                                return Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 36),
                                  width: constraints.maxWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      width: 1,
                                    ),
                                  ),
                                  child: const LabelMedium(
                                      text: "Click to pick image"),
                                );
                              },
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: LabelLarge(
                                text: 'Change image',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        Container(
          padding: padding,
          decoration: decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextInput(
                        onText: (d) => updateFormState({"retailPrice": d}),
                        label: "Retail price / unit quantity",
                        placeholder: "",
                        error: error['retailPrice'] ?? '',
                        initialText: '${product['retailPrice'] ?? ''}',
                        type: TextInputType.number,
                      )),
                  const WhiteSpacer(width: 8),
                  Expanded(
                      flex: 1,
                      child: TextInput(
                        onText: (d) => updateFormState({"wholesalePrice": d}),
                        label: "Wholesale price / unit quantity",
                        placeholder: "",
                        error: error['wholesalePrice'] ?? '',
                        initialText: '${product['wholesalePrice'] ?? ''}',
                        type: TextInputType.number,
                      ))
                ],
              ),
              const WhiteSpacer(height: 8),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextInput(
                        onText: (d) => updateFormState({"purchase": d}),
                        label: "Cost price / unit quantity",
                        placeholder: "",
                        error: error['purchase'] ?? '',
                        initialText: '${product['purchase'] ?? ''}',
                        type: TextInputType.number,
                      )),
                  const WhiteSpacer(width: 8),
                  Expanded(flex: 1, child: Container())
                ],
              )
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        Container(
          padding: padding,
          decoration: decoration,
          child: _descriptionInput(),
        ),
        const WhiteSpacer(height: 16),
        Container(
          padding: padding,
          decoration: decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextInput(
                        onText: (d) => updateFormState({"quantity": d}),
                        label: "Quantity",
                        placeholder: "Current stock quantity",
                        error: error['quantity'] ?? '',
                        initialText: '${product['quantity'] ?? ''}',
                        type: TextInputType.number,
                      )),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: DateInput(
                        onText: (d) => updateFormState({"expire": d}),
                        label: "Expire",
                        placeholder: "YYYY-MM-DD ( Optional )",
                        error: error['expire'] ?? '',
                        initialText: product['expire'] ?? '',
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 360 * 100)),
                        // type: TextInputType.datetime,
                      )),
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
          child: TextButton(
            onPressed: loading ? null : _createProduct,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
              // overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onPrimary),
            ),
            child: BodyLarge(
              text: loading ? "Waiting..." : "Continue",
            ),
          ),
        )
      ],
    );
  }

  Widget _smallScreenView() {
    var decoration = BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8));
    var padding = const EdgeInsets.all(16);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: padding,
          decoration: decoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInput(
                      onText: (d) {
                        // error['product']='';
                        updateFormState({"product": d});
                      },
                      label: "Name",
                      placeholder: 'Brand + generic name',
                      error: error['product'] ?? '',
                      initialText: product['product'] ?? '',
                    ),
                    const WhiteSpacer(height: 8),
                    TextInput(
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
                    ),
                    const WhiteSpacer(height: 8),
                    ChoicesInput(
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
                    ),
                    const WhiteSpacer(height: 16),
                    FileSelect(
                      onFile: (file) {
                        _fileData = file;
                      },
                      builder: (isEmpty, onPress) {
                        return InkWell(
                          onTap: onPress,
                          child: isEmpty
                              ? LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      width: constraints.maxWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          width: 1,
                                        ),
                                      ),
                                      child: const LabelMedium(
                                          text: "Click to pick image"),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: LabelLarge(
                                    text: 'Change image',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        Container(
          padding: padding,
          decoration: decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInput(
                onText: (d) => updateFormState({"retailPrice": d}),
                label: "Retail price / unit quantity",
                placeholder: "",
                error: error['retailPrice'] ?? '',
                initialText: '${product['retailPrice'] ?? ''}',
                type: TextInputType.number,
              ),
              TextInput(
                onText: (d) => updateFormState({"wholesalePrice": d}),
                label: "Wholesale price / unit quantity",
                placeholder: "",
                error: error['wholesalePrice'] ?? '',
                initialText: '${product['wholesalePrice'] ?? ''}',
                type: TextInputType.number,
              ),
              const WhiteSpacer(height: 8),
              TextInput(
                onText: (d) => updateFormState({"purchase": d}),
                label: "Cost price / unit quantity",
                placeholder: "",
                error: error['purchase'] ?? '',
                initialText: '${product['purchase'] ?? ''}',
                type: TextInputType.number,
              )
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        Container(
          padding: padding,
          decoration: decoration,
          child: _descriptionInput(),
        ),
        const WhiteSpacer(height: 16),
        Container(
          padding: padding,
          decoration: decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInput(
                onText: (d) => updateFormState({"quantity": d}),
                label: "Quantity",
                placeholder: "Current stock quantity",
                error: error['quantity'] ?? '',
                initialText: '${product['quantity'] ?? ''}',
                type: TextInputType.number,
              ),
              DateInput(
                onText: (d) => updateFormState({"expire": d}),
                label: "Expire",
                placeholder: "YYYY-MM-DD ( Optional )",
                error: error['expire'] ?? '',
                initialText: product['expire'] ?? '',
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 360 * 100)),
                // type: TextInputType.datetime,
              )
            ],
          ),
        ),
        const WhiteSpacer(height: 16),
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(minWidth: 200),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: TextButton(
            onPressed: loading ? null : _createProduct,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
              // overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onPrimary),
            ),
            child: BodyLarge(
              text: loading ? "Waiting..." : "Continue",
            ),
          ),
        )
      ],
    );
  }

  _createProduct() {
    setState(() {
      error = {};
      loading = true;
    });
    createOrUpdateProduct(context, error, loading, false, {
      ...product,
      'stockable': true,
      'saleable': true,
      'purchasable': true,
      'supplier': 'general',
      // 'retailPrice': product['retailPrice'],
      'wholesalePrice': product['wholesalePrice'] ?? product['retailPrice']
    }, _fileData).then((value) {
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
