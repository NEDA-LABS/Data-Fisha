import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_edit_form.dart';

class ProductEditPage extends PageBase {
  final Map product;
  final OnBackPage onBackPage;

  const ProductEditPage(
    this.product, {
    Key? key,
    required this.onBackPage,
  }) : super(key: key, pageName: 'ProductEditPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductEditPage>{
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
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ProductUpdateForm(widget.product, onBackPage: widget.onBackPage),
          ),
        )
      ],
    );
  }
}