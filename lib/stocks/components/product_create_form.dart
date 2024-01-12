import 'package:flutter/material.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_form.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductCreateForm extends StatelessWidget {
  final OnBackPage onBackPage;

  const ProductCreateForm({
    Key? key,
    required this.onBackPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductForm(
      product: const {},
      onSubmit: _onSubmitCreateProduct,
    );
  }

  Future _onSubmitCreateProduct({
    required List<FileData?> files,
    required Map product,
    required Map shop,
  }) {
    return createProductRemote(
      shop: shop,
      product: product,
      fileData: files,
    ).then((value) => onBackPage());
  }
}
