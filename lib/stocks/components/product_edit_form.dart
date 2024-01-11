import 'package:flutter/foundation.dart';
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
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/custom_text_editing_controller.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/helpers/markdown_map.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductUpdateForm extends StatefulWidget {
  final Map product;
  final OnBackPage onBackPage;

  const ProductUpdateForm(
    this.product, {
    Key? key,
    required this.onBackPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductUpdateForm> {
  Map<String, dynamic> product = {};
  Map<String, dynamic> error = {};
  var loading = false;
  List<FileData?> _fileData = [];
  CustomTextEditingController? _editTextAreaController;
  List _categories = [];

  clearFormState() {
    product = {};
  }

  updateFormState(Map<String, dynamic> data) {
    product.addAll(data);
  }

  refresh() => setState(() {});

  @override
  void initState() {
    _editTextAreaController = CustomTextEditingController(getTextEditorMDMap,
        text: widget.product['description'] ?? '');
    product.addAll({
      "product": widget.product['product'],
      "description": widget.product['description'],
      "images": widget.product['images'],
      "barcode": widget.product['barcode'] ?? '',
      "category": widget.product['category'],
      "purchase": widget.product['purchase'],
      "retailPrice": widget.product['retailPrice'],
      "wholesalePrice": widget.product['wholesalePrice'],
      "expire": widget.product['expire'] ?? '',
      "id": widget.product['id'],
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    if (isSmallScreen) {
      return _smallScreenView();
    } else {
      return _largeScreenView();
    }
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
          initialText: product['description'] ?? '',
        ),
      ],
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
                      choice: _categories,
                      onChoice: (d) {
                        _categories = itOrEmptyArray(d);
                        updateFormState({
                          "category":
                              _categories.map((e) => e['name'] ?? '').join(',')
                        });
                        refresh();
                      },
                      label: "Category",
                      placeholder: 'Select category',
                      error: error['category'] ?? '',
                      getAddWidget: () => const CreateCategoryContent(),
                      onField: (x) => '${x['name']}',
                      onLoad: getCategoryFromCacheOrRemote,
                    ),
                  ],
                ),
              ),
              const WhiteSpacer(width: 8),
              Expanded(
                flex: 2,
                child: _fileSelectWidget(minHeight: 200, marginTop: 36),
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
            onPressed: loading ? null : _updateProduct,
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
                      choice: _categories,
                      onChoice: (d) {
                        _categories = itOrEmptyArray(d);
                        updateFormState({
                          "category":
                              _categories.map((e) => e['name'] ?? '').join(',')
                        });
                        refresh();
                      },
                      label: "Category",
                      placeholder: 'Select category',
                      error: error['category'] ?? '',
                      getAddWidget: () => const CreateCategoryContent(),
                      onField: (x) => '${x['name']}',
                      onLoad: getCategoryFromCacheOrRemote,
                    ),
                    const WhiteSpacer(height: 16),
                    _fileSelectWidget(minHeight: 100, marginTop: 0)
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
            onPressed: loading ? null : _updateProduct,
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

  _updateProduct() {
    setState(() {
      error = {};
      loading = true;
    });
    createOrUpdateProduct(context, error, loading, true, product, _fileData)
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

  String _getImageUrl(product) {
    var images = itOrEmptyArray(product['images']);
    if (images.length > 0) {
      return images[0];
    } else {
      return '';
    }
  }

  Widget _changeImageLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LabelLarge(
        text: 'Change image',
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _fileSelectWidget(
      {required double minHeight, required double marginTop}) {
    return FileSelect(
      onFile: (file) {
        _fileData = file;
      },
      builder: (isEmpty, onPress) {
        return InkWell(
          onTap: onPress,
          child: isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(minHeight: minHeight),
                          alignment: Alignment.center,
                          width: constraints.maxWidth,
                          margin: EdgeInsets.only(
                              top: _getImageUrl(product).isNotEmpty
                                  ? 0
                                  : marginTop),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.background,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _getImageUrl(product),
                              errorBuilder: (context, error, stackTrace) {
                                return const LabelMedium(
                                  text: "Click to pick image",
                                );
                              },
                            ),
                          ),
                        ),
                        _getImageUrl(product).isNotEmpty
                            ? _changeImageLabel()
                            : Container()
                      ],
                    );
                  },
                )
              : _changeImageLabel(),
        );
      },
    );
  }

// _mobileQrScan(v) {
//   var a = ifDoElse(
//     (_) => isNativeMobilePlatform(),
//     (_) => IconButton(
//       onPressed: () {
//         fullScreeDialog(context, (p0) {
//           return const ReadBarcodeView();
//         }).then((value) {
//           updateFormState({"barcode": value});
//           refresh();
//         }).catchError((error) {
//           if (kDebugMode) {
//             print(error);
//           }
//         });
//       },
//       icon: const Icon(Icons.qr_code_scanner),
//     ),
//     (_) => const SizedBox(),
//   );
//   return a(v);
// }
}
