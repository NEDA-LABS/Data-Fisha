import 'package:flutter/material.dart';
import 'package:smartstock/sales/components/add_to_cart.dart';
import 'package:smartstock/sales/components/product_card.dart';
import 'package:smartstock/sales/models/cart.model.dart';

Widget listOfProducts({
  @required List<dynamic> products,
  @required onAddToCart,
  @required int Function(dynamic) onGetPrice,
}) =>
    GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
        itemCount: products.length,
        shrinkWrap: true,
        gridDelegate: _delegate(),
        itemBuilder: (context, index) => InkWell(
            onTap: () => _productPressed(
                context, products[index], onGetPrice, onAddToCart),
            child: productCardItem(
                productCategory: _getCategory(products[index]),
                productName: _getName(products[index]),
                productPrice: onGetPrice(products[index]))));

_getName(product) => '${product['product']}';

_getCategory(product) => '${product['category']}';

_delegate() =>
    const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180);

_productPressed(context, product, onGetPrice, onAddToCart) =>
    addToCartView(
        context: context,
      onGetPrice: onGetPrice,
        cart: CartModel(product: product, quantity: 1),
        onAddToCart: onAddToCart,
      );

int _getPrice(product, wholesale) =>
    product[wholesale ? "wholesalePrice" : 'retailPrice'] is double
        ? product[wholesale ? "wholesalePrice" : 'retailPrice'].toInt()
        : product[wholesale ? "wholesalePrice" : 'retailPrice'];
