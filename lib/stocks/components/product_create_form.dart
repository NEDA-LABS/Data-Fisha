import 'package:flutter/material.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/product_form.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductCreateForm extends StatelessWidget {
  final OnBackPage onBackPage;

  const ProductCreateForm({
    super.key,
    required this.onBackPage,
  });

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
    return productCreateRemote(
      shop: shop,
      product: product,
      fileData: files,
    ).then((value) => onBackPage());
  }
}
