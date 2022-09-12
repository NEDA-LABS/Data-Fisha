import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';
import 'package:smartstock/stocks/states/product_create.dart';


List<Widget> productUpdateForm(ProductCreateState state, context) {
  return [
    TextInput(
        onText: (d) => state.updateFormState({"barcode": d}),
        label: "Barcode / Qrcode",
        placeholder: "Optional",
        error: state.error['barcode'] ?? '',
        initialText: state.product['barcode']??'',
        icon: _mobileQrScan('')),
    ChoicesInput(
      onText: (d) {
        state.updateFormState({"category": d});
        state.refresh();
      },
      label: "Category",
      placeholder: 'Select category',
      error: state.error['category'] ?? '',
      initialText: state.product['category']??'',
      getAddWidget: () => createCategoryContent(),
      onField: (x)=>'${x['name']}',
      onLoad: getCategoryFromCacheOrRemote,
    ),
    TextInput(
      onText: (d) => state.updateFormState({"purchase": d}),
      label: "Purchase Cost ( Tsh ) / Unit price",
      placeholder: "",
      error: state.error['purchase'] ?? '',
      initialText: '${state.product['purchase']??''}',
      type: TextInputType.number,
    ),
    TextInput(
      onText: (d) => state.updateFormState({"retailPrice": d}),
      label: "Retail price ( Tsh ) / Unit price",
      placeholder: "",
      error: state.error['retailPrice'] ?? '',
      initialText: '${state.product['retailPrice']??''}',
      type: TextInputType.number,
    ),
    TextInput(
      onText: (d) => state.updateFormState({"wholesalePrice": d}),
      label: "Wholesale price ( Tsh ) / Unit price",
      placeholder: "",
      error: state.error['wholesalePrice'] ?? '',
      initialText: '${state.product['wholesalePrice']??''}',
      type: TextInputType.number,
    ),
    Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: OutlinedButton(
          onPressed: state.loading ? null : () => state.create(context),
          child: Text(
            state.loading ? "Waiting..." : "Continue.",
            style: const TextStyle(fontSize: 16),
          )),
    )
  ];
}

var _mobileQrScan = ifDoElse(
  (_) => isNativeMobilePlatform(),
  (_) => IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner)),
  (_) => const SizedBox(),
);
