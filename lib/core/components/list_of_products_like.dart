import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/services/util.dart';

typedef OnAddToCart = Function(dynamic);
typedef OnAddToCartView = Function(dynamic product, OnAddToCart onAddToCart);
typedef OnGetPrice = dynamic Function(dynamic);

Widget listOfProducts({
  required List<dynamic> products,
  required onAddToCart,
  required OnGetPrice onGetPrice,
  required OnAddToCartView onAddToCartView,
}) {
  return GridView.builder(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
    itemCount: products.length,
    shrinkWrap: true,
    gridDelegate: _delegate(),
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () => onAddToCartView(products[index], onAddToCart),
        child: _productCardItem(
          category: _getCategory(products[index]),
          name: _getName(products[index]),
          price: onGetPrice(products[index]),
        ),
      );
    },
  );
}

var _getName = propertyOr('product', propertyOr('name', (_) => ''));

var _getCategory = propertyOr('category', (p0) => '');

_delegate() =>
    const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180);

Widget _productCardItem({String? category, String? name, dynamic price}) {
  return Card(
    color: Colors.white,
    // elevation: 4,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Text(
              category ?? '',
              style: const TextStyle(
                  color: Colors.grey, overflow: TextOverflow.ellipsis),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                name ?? '',
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                price != null
                    ? NumberFormat.currency(name: 'TZS ')
                        .format(doubleOrZero(price))
                    : '',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  // fontSize: 14
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
