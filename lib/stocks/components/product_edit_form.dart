import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductUpdateForm extends StatefulWidget {
  final Map product;
  const ProductUpdateForm(this.product, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductUpdateForm> {
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
  void initState() {
    product.addAll({
      "barcode": widget.product['barcode'],
      "category": widget.product['category'],
      "purchase": widget.product['purchase'],
      "retailPrice": widget.product['retailPrice'],
      "wholesalePrice": widget.product['wholesalePrice'],
      "id": widget.product['id'],
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInput(
            onText: (d) => updateFormState({"barcode": d}),
            label: "Barcode / Qrcode",
            placeholder: "Optional",
            error: error['barcode'] ?? '',
            initialText: product['barcode'] ?? '',
            icon: _mobileQrScan('')),
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
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: OutlinedButton(
              onPressed: loading ? null : _updateProduct,
              child: Text(
                loading ? "Waiting..." : "Continue.",
                style: const TextStyle(fontSize: 16),
              )),
        )
      ],
    );
  }

  _updateProduct() {
    setState(() {
      error = {};
      loading = true;
    });
    createOrUpdateProduct(
      context,
      error,
      loading,
      true,
      product,
    ).catchError((error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: const Text("Error!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              content: Text('$error')));
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  final _mobileQrScan = ifDoElse(
    (_) => isNativeMobilePlatform(),
    (_) =>
        IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner)),
    (_) => const SizedBox(),
  );
}
