import 'package:flutter/material.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_create_form.dart';

class ProductCreatePage extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const ProductCreatePage({Key? key, required this.onGetModulesMenu})
      : super(key: key);

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Add product",
      showBack: true,
      backLink: '/stock/products',
      onBack: () {
        Navigator.of(context).maybePop();
      },
      showSearch: false,
      context: context,
    );
  }

  @override
  Widget build(context) => ResponsivePage(
        menus: onGetModulesMenu(context),
        current: '/stock/',
        sliverAppBar: _appBar(context),
        staticChildren: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              // padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: const ProductCreateForm(),
            ),
          )
        ],
        // onBody: (d) => SingleChildScrollView(
        //   child: ,
        // ),
      );
}
