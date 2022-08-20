import 'dart:io';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/text_input.dart';

import '../states/product_form_state.dart';

List<Widget> productCreateForm(ProductFormState state) {
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
    textInput(
      onText: (d) => state.updateFormState({"purchase": d}),
      label: "Cost ( Tsh ) / Unit price",
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
      onText: (d) => state.updateFormState({"wholesaleQuantity": d}),
      label: "Wholesale quantity",
      placeholder: "",
      error: state.errors['wholesaleQuantity'] ?? '',
      initialText: state.productForm['wholesaleQuantity'],
      type: TextInputType.number,
    ),
  ];
}

var _mobileQrScan = ifDoElse(
  (_) =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android,
  (_) => IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner)),
  (_) => const SizedBox(),
);
