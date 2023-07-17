import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/product_create_form.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';

class ProductCreatePage extends StatelessWidget {
  final OnBackPage onBackPage;
  final InventoryType inventoryType;

  const ProductCreatePage({
    Key? key,
    required this.inventoryType,
    required this.onBackPage,
  }) : super(key: key);

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: _getPageTitle(inventoryType),
      showBack: true,
      backLink: '/stock/products',
      onBack: onBackPage,
      showSearch: false,
      context: context,
    );
  }

  @override
  Widget build(context) => ResponsivePage(
        current: '/stock/',
        sliverAppBar: _appBar(context),
        staticChildren: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ProductCreateForm(
                inventoryType: inventoryType,
                onBackPage: onBackPage,
              ),
            ),
          )
        ],
      );

  _getPageTitle(InventoryType inventoryType) {
    switch (inventoryType) {
      case InventoryType.product:
        return "Add product";
      case InventoryType.rawMaterial:
        return "Add raw material";
      case InventoryType.nonStockProduct:
        return "Add non-stock product";
      default:
        return "Add product";
    }
  }
}
