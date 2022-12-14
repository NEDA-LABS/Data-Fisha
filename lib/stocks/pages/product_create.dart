import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/stocks/components/product_create_form.dart';
import 'package:smartstock/stocks/states/product_create.dart';

class ProductCreatePage extends StatelessWidget {
  const ProductCreatePage({Key? key}) : super(key: key);

  _appBar(context) {
    return StockAppBar(
      title: "Add product",
      showBack: true,
      backLink: '/stock/products',
      showSearch: false, context: context,
    );
  }

  @override
  Widget build(context) => ResponsivePage(
      menus: moduleMenus(),
      current: '/stock/',
      sliverAppBar: _appBar(context),
      onBody: (d) => Scaffold(
          body: SingleChildScrollView(
              child: Center(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: Consumer<ProductCreateState>(
                          builder: (context, state) => Column(
                              children:
                                  productCreateForm(state!, context))))))));
}
