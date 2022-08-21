import 'dart:io';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/text_input.dart';

import '../../core/components/choices_input.dart';
import '../states/product_form_state.dart';

List<Widget> productCreateForm(ProductFormState state, context) {
  return [
    textInput(
        onText: (d) => state.updateFormState({"product": d}),
        label: "Name",
        placeholder: "Brand + Generic name",
        error: state.errors['product'] ?? '',
        initialText: state.productForm['product']),
    textInput(
        onText: (d) => state.updateFormState({"barcode": d}),
        label: "Barcode / Qrcode",
        placeholder: "Optional",
        error: state.errors['barcode'] ?? '',
        initialText: state.productForm['barcode'],
        icon: _mobileQrScan('')),
    choicesInput(
      onText: (d) => state.updateFormState({"category": d}),
      label: "Category",
      error: state.errors['category'] ?? '',
      initialText: state.productForm['category'],
    ),
    choicesInput(
      onText: (d) => state.updateFormState({"supplier": d}),
      label: "Supplier",
      error: state.errors['supplier'] ?? '',
      initialText: state.productForm['supplier'],
    ),
    textInput(
      onText: (d) => state.updateFormState({"purchase": d}),
      label: "Purchase Cost ( Tsh ) / Unit price",
      placeholder: "",
      error: state.errors['purchase'] ?? '',
      initialText: state.productForm['purchase'],
      type: TextInputType.number,
    ),
    textInput(
      onText: (d) => state.updateFormState({"retailPrice": d}),
      label: "Retail price ( Tsh ) / Unit price",
      placeholder: "",
      error: state.errors['retailPrice'] ?? '',
      initialText: state.productForm['retailPrice'],
      type: TextInputType.number,
    ),
    textInput(
      onText: (d) => state.updateFormState({"wholesalePrice": d}),
      label: "Wholesale price ( Tsh ) / Unit price",
      placeholder: "",
      error: state.errors['wholesalePrice'] ?? '',
      initialText: state.productForm['wholesalePrice'],
      type: TextInputType.number,
    ),
    textInput(
      onText: (d) => state.updateFormState({"quantity": d}),
      label: "Quantity",
      placeholder: "Current stock quantity",
      error: state.errors['quantity'] ?? '',
      initialText: state.productForm['quantity'],
      type: TextInputType.number,
    ),
    textInput(
        onText: (d) => state.updateFormState({"expire": d}),
        label: "Expire",
        placeholder: "YYYY-MM-DD ( Optional )",
        error: state.errors['expire'] ?? '',
        initialText: state.productForm['expire'],
    type: TextInputType.datetime),
    Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: OutlinedButton(onPressed: () {}, child: const Text("Continue.", style: TextStyle(fontSize: 16),)),
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
