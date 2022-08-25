import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/text_input.dart';
import 'package:smartstock_pos/stocks/components/create_category_content.dart';
import 'package:smartstock_pos/stocks/components/create_supplier_content.dart';
import 'package:smartstock_pos/stocks/services/category.dart';
import 'package:smartstock_pos/stocks/services/supplier.dart';

import '../../core/components/choices_input.dart';
import '../states/product_create.dart';

List<Widget> productCreateForm(ProductFormState state, context) {
  return [
    textInput(
        onText: (d) => state.updateFormState({"product": d}),
        label: "Name",
        placeholder: "Brand + Generic name",
        error: state.error['product'] ?? '',
        initialText: state.product['product']),
    textInput(
        onText: (d) => state.updateFormState({"barcode": d}),
        label: "Barcode / Qrcode",
        placeholder: "Optional",
        error: state.error['barcode'] ?? '',
        initialText: state.product['barcode'],
        icon: _mobileQrScan('')),
    choicesInput(
      onText: (d) {
        state.updateFormState({"category": d});
        state.refresh();
      },
      label: "Category",
      error: state.error['category'] ?? '',
      initialText: state.product['category'],
      onAdd: () => createCategoryContent(),
      onLoad: getCategoryFromCacheOrRemote,
    ),
    choicesInput(
      onText: (d) {
        state.updateFormState({"supplier": d});
        state.refresh();
      },
      label: "Supplier",
      error: state.error['supplier'] ?? '',
      initialText: state.product['supplier'],
      onAdd: () => createSupplierContent(),
      onLoad: getSupplierFromCacheOrRemote,
    ),
    textInput(
      onText: (d) => state.updateFormState({"purchase": d}),
      label: "Purchase Cost ( Tsh ) / Unit price",
      placeholder: "",
      error: state.error['purchase'] ?? '',
      initialText: state.product['purchase'].toString(),
      type: TextInputType.number,
    ),
    textInput(
      onText: (d) => state.updateFormState({"retailPrice": d}),
      label: "Retail price ( Tsh ) / Unit price",
      placeholder: "",
      error: state.error['retailPrice'] ?? '',
      initialText: state.product['retailPrice'].toString(),
      type: TextInputType.number,
    ),
    textInput(
      onText: (d) => state.updateFormState({"wholesalePrice": d}),
      label: "Wholesale price ( Tsh ) / Unit price",
      placeholder: "",
      error: state.error['wholesalePrice'] ?? '',
      initialText: state.product['wholesalePrice'].toString(),
      type: TextInputType.number,
    ),
    textInput(
      onText: (d) => state.updateFormState({"quantity": d}),
      label: "Quantity",
      placeholder: "Current stock quantity",
      error: state.error['quantity'] ?? '',
      initialText: state.product['quantity'].toString(),
      type: TextInputType.number,
    ),
    textInput(
        onText: (d) => state.updateFormState({"expire": d}),
        label: "Expire",
        placeholder: "YYYY-MM-DD ( Optional )",
        error: state.error['expire'] ?? '',
        initialText: state.product['expire'],
        type: TextInputType.datetime),
    Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: OutlinedButton(
          onPressed: state.loading ? null : ()=>state.create(context),
          child: Text(
            state.loading ? "Waiting..." : "Continue.",
            style: const TextStyle(fontSize: 16),
          )),
    )
  ];
}

var _mobileQrScan = ifDoElse(
  (_) =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android,
  (_) => IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner)),
  (_) => const SizedBox(),
);
