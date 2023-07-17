import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ReadBarcodeView.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';
import 'package:smartstock/stocks/services/supplier.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        ChoicesInput(
          onText: (d) {
            updateFormState({"supplier": d});
            refresh();
          },
          label: "Supplier",
          placeholder: 'Select supplier',
          error: error['supplier'] ?? '',
          initialText: product['supplier'] ?? '',
          getAddWidget: () => const CreateSupplierContent(),
          onField: (x) => '${x['name']}',
          onLoad: getSupplierFromCacheOrRemote,
        ),
        TextInput(
          onText: (d) => updateFormState({"purchase": d}),
          label: "Purchase price / Unit quantity",
          placeholder: "",
          error: error['purchase'] ?? '',
          initialText: '${product['purchase'] ?? ''}',
          type: TextInputType.number,
        ),
        widget.inventoryType != InventoryType.rawMaterial
            ? TextInput(
          onText: (d) => updateFormState({"retailPrice": d}),
          label: "Retail price / Unit quantity",
          placeholder: "",
          error: error['retailPrice'] ?? '',
          initialText: '${product['retailPrice'] ?? ''}',
          type: TextInputType.number,
        )
            : Container(),
        widget.inventoryType != InventoryType.rawMaterial
            ? TextInput(
          onText: (d) => updateFormState({"wholesalePrice": d}),
          label: "Wholesale price / Unit price",
          placeholder: "",
          error: error['wholesalePrice'] ?? '',
          initialText: '${product['wholesalePrice'] ?? ''}',
          type: TextInputType.number,
        )
            : Container(),
        widget.inventoryType != InventoryType.nonStockProduct
            ? TextInput(
          onText: (d) => updateFormState({"quantity": d}),
          label: "Quantity",
          placeholder: "Current stock quantity",
          error: error['quantity'] ?? '',
          initialText: '${product['quantity'] ?? ''}',
          type: TextInputType.number,
        )
            : Container(),
        widget.inventoryType == InventoryType.nonStockProduct
            ? Container()
            : DateInput(
          onText: (d) => updateFormState({"expire": d}),
          label: "Expire",
          placeholder: "YYYY-MM-DD ( Optional )",
          error: error['expire'] ?? '',
          initialText: product['expire'] ?? '',
          firstDate: DateTime.now(),
          initialDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 360 * 100)),
          // type: TextInputType.datetime,
        ),
        Container(
          height: 80,
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: OutlinedButton(
            onPressed: loading ? null : _createProduct,
            child: Text(
              loading ? "Waiting..." : "Continue.",
              style: const TextStyle(fontSize: 16),
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
      'stockable': widget.inventoryType != InventoryType.nonStockProduct,
      'saleable': (widget.inventoryType == InventoryType.product ||
          widget.inventoryType == InventoryType.nonStockProduct),
      'purchasable': true,
      'retailPrice': widget.inventoryType == InventoryType.rawMaterial
          ? '0'
          : product['retailPrice'] ?? '0',
      'wholesalePrice': widget.inventoryType == InventoryType.rawMaterial
          ? '0'
          : product['wholesalePrice'] ?? '0'
    }).then((value) {
      widget.onBackPage();
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Error!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              content: Text('$error'),
            ),
      );
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
