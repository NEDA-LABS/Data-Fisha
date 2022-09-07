import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:modular_interfaces/src/route/modular_arguments.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_edit_form.dart';
import 'package:smartstock/stocks/states/product_create.dart';

import '../components/product_create_form.dart';

class ProductEditPage extends StatelessWidget {
  final String productName;
  const ProductEditPage(this.productName,{Key key}) : super(key: key);

  _appBar(context) {
    return StockAppBar(
      title: "Update $productName detail",
      showBack: true,
      backLink: '/stock/products',
      showSearch: false,
    );
  }

  @override
  Widget build(context) {
    return responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
            appBar: _appBar(context),
            body: SingleChildScrollView(
                child: Center(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                        child: Consumer<ProductCreateState>(
                            builder: (context, state) => Column(
                                children:
                                    productUpdateForm(state, context))))))));
  }
}
