import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/PageBase.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/product_edit_form.dart';

class ProductEditPage extends PageBase {
  final Map product;
  final OnBackPage onBackPage;

  const ProductEditPage({
    Key? key,
    required this.onBackPage,
    required this.product,
  }) : super(key: key, pageName: 'ProductEditPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductEditPage> {
  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Update ${widget.product['product']}",
      showBack: true,
      backLink: '/stock/products',
      showSearch: false,
      onBack: widget.onBackPage,
      context: context,
    );
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      current: '/stock/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        const WhiteSpacer(height: 24),
        ProductUpdateForm(
            product: widget.product, onBackPage: widget.onBackPage),
        const WhiteSpacer(height: 24),
      ],
    );
  }
}
