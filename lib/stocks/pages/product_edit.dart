import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/stocks/components/product_edit_form.dart';

class ProductEditPage extends StatelessWidget {
  final Map product;

  const ProductEditPage(this.product, {Key? key}) : super(key: key);

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Update ${product['product']} detail",
      showBack: true,
      backLink: '/stock/products',
      showSearch: false,
      onBack: () {
        Navigator.of(context).maybePop();
      },
      context: context,
    );
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      menus: getAppModuleMenus(context),
      current: '/stock/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ProductUpdateForm(product),
          ),
        )
      ],
    );
  }
}
