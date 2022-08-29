import 'package:flutter/material.dart';

import '../models/cart.model.dart';
import 'add_to_cart.dart';
import 'product_card.dart';

Widget listOfProducts({
  wholesale = false,
  @required List<dynamic> products,
  @required onAddToCart,
}) =>
    GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
        itemCount: products.length,
        shrinkWrap: true,
        gridDelegate: _delegate(),
        itemBuilder: (context, index) => InkWell(
            onTap: () => _productPressed(
                context, products[index], wholesale, onAddToCart),
            child: productCardItem(
                productCategory: _getCategory(products[index]),
                productName: _getName(products[index]),
                productPrice: _getPrice(products[index], wholesale))));

_getName(product) => '${product['product']}';

_getCategory(product) => '${product['category']}';

_delegate() =>
    const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180);

_productPressed(context, product, wholesale, onAddToCart) => addToCartView(
    context: context,
    wholesale: wholesale,
    cart: CartModel(product: product, quantity: 1),
    onAddToCart: onAddToCart);

int _getPrice(product, wholesale) =>
    product[wholesale ? "wholesalePrice" : 'retailPrice'] is double
        ? product[wholesale ? "wholesalePrice" : 'retailPrice'].toInt()
        : product[wholesale ? "wholesalePrice" : 'retailPrice'];
