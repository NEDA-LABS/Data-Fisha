import 'package:flutter/material.dart';
import 'package:smartstock/core/components/product_like_card.dart';
import 'package:smartstock/core/services/util.dart';

Widget listOfProducts({
  required List<dynamic> products,
  required onAddToCart,
  required dynamic Function(dynamic) onGetPrice,
  required
      Function(dynamic product, Function(dynamic) onAddToCart) onAddToCartView,
}) =>
    GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
        itemCount: products.length,
        shrinkWrap: true,
        gridDelegate: _delegate(),
        itemBuilder: (context, index) => InkWell(
            onTap: () => onAddToCartView(products[index], onAddToCart),
            child: productCardItem(
                productCategory: _getCategory(products[index]),
                productName: _getName(products[index]),
                productPrice: onGetPrice(products[index]))));

var _getName = propertyOr('product', (p0) => '');

var _getCategory = propertyOr('category', (p0) => '');

_delegate() =>
    const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180);
