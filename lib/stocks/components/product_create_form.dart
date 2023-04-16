import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ReadBarcodeView.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';
import 'package:smartstock/stocks/services/supplier.dart';

class ProductCreateForm extends StatefulWidget {
  const ProductCreateForm({Key? key}) : super(key: key);

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
          icon: _mobileQrScan(''),
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
          label: "Purchase Cost ( Tsh ) / Unit price",
          placeholder: "",
          error: error['purchase'] ?? '',
          initialText: '${product['purchase'] ?? ''}',
          type: TextInputType.number,
        ),
        TextInput(
          onText: (d) => updateFormState({"retailPrice": d}),
          label: "Retail price ( Tsh ) / Unit price",
          placeholder: "",
          error: error['retailPrice'] ?? '',
          initialText: '${product['retailPrice'] ?? ''}',
          type: TextInputType.number,
        ),
        TextInput(
          onText: (d) => updateFormState({"wholesalePrice": d}),
          label: "Wholesale price ( Tsh ) / Unit price",
          placeholder: "",
          error: error['wholesalePrice'] ?? '',
          initialText: '${product['wholesalePrice'] ?? ''}',
          type: TextInputType.number,
        ),
        TextInput(
          onText: (d) => updateFormState({"quantity": d}),
          label: "Quantity",
          placeholder: "Current stock quantity",
          error: error['quantity'] ?? '',
          initialText: '${product['quantity'] ?? ''}',
          type: TextInputType.number,
        ),
        TextInput(
            onText: (d) => updateFormState({"expire": d}),
            label: "Expire",
            placeholder: "YYYY-MM-DD ( Optional )",
            error: error['expire'] ?? '',
            initialText: product['expire'] ?? '',
            type: TextInputType.datetime),
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
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

  _mobileQrScan(v) {
    var a = ifDoElse(
      (_) => isNativeMobilePlatform(),
      (_) => IconButton(
        onPressed: () {
          fullScreeDialog(context, (p0) {
            return const ReadBarcodeView();
          }).then((value) {
            updateFormState({"barcode": value});
            refresh();
          }).catchError((error) {
            if (kDebugMode) {
              print(error);
            }
          });
        },
        icon: const Icon(Icons.qr_code_scanner),
      ),
      (_) => const SizedBox(),
    );
    return a(v);
  }

  _createProduct() {
    setState(() {
      error = {};
      loading = true;
    });
    createOrUpdateProduct(context, error, loading, false, product)
        .then((value) {
      Navigator.of(context).maybePop();
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
