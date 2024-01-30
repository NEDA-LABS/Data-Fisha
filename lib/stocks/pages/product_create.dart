import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/PageBase.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/product_create_form.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';

class ProductCreatePage extends PageBase {
  final OnBackPage onBackPage;
  final InventoryType inventoryType;

  const ProductCreatePage({
    super.key,
    required this.inventoryType,
    required this.onBackPage,
  }) : super(pageName: 'ProductCreatePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductCreatePage> {
  _appBar(context) {
    return SliverSmartStockAppBar(
      title: _getPageTitle(widget.inventoryType),
      showBack: true,
      onBack: widget.onBackPage,
      showSearch: false,
      context: context,
    );
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      sliverAppBar: _appBar(context),
      staticChildren: [
        const WhiteSpacer(height: 24),
        ProductCreateForm(onBackPage: widget.onBackPage),
        const WhiteSpacer(height: 24),
      ],
    );
  }

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
