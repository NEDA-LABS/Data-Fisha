import 'package:flutter/material.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/add_to_cart.dart';
import 'package:smartstock/sales/components/product_card.dart';
import 'package:smartstock/sales/models/cart.model.dart';

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

_productPressed(context, product, wholesale, onAddToCart) =>
    addToCartView(
        context: context,
        wholesale: wholesale,
        cart: CartModel(product: product, quantity: 1),
        onAddToCart: onAddToCart,
      );

dynamic _getPrice(product, wholesale) =>
    doubleOrZero(product[wholesale ? "wholesalePrice" : 'retailPrice']);
