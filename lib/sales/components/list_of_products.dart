import 'package:flutter/material.dart';
import 'package:smartstock/sales/components/product_card.dart';

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

_getName(product) => '${product['product']}';

_getCategory(product) => '${product['category']}';

_delegate() =>
    const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180);
