import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/services/util.dart';

typedef OnAddToCart = Function(dynamic);
typedef OnAddToCartView = Function(dynamic product, OnAddToCart onAddToCart);
typedef OnGetPrice = dynamic Function(dynamic);

class ListOfProductsLike extends StatelessWidget {
  final List<dynamic> products;
  final OnAddToCart onAddToCart;
  final OnGetPrice onGetPrice;
  final OnAddToCartView onAddToCartView;

  const ListOfProductsLike({
    required this.products,
    required this.onAddToCart,
    required this.onGetPrice,
    required this.onAddToCartView,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
      itemCount: products.length,
      shrinkWrap: true,
      gridDelegate: _delegate(),
      itemBuilder: (context, index) {
        return _productCardItem(
          product: products[index],
          category: _getCategory(products[index]),
          name: _getName(products[index]),
          price: onGetPrice(products[index]),
        );
      },
    );
  }

  _getName(data) {
    var g = propertyOr('product', propertyOr('name', (_) => ''));
    return g(data);
  }

  _getCategory(data) {
    var g = propertyOr('category', (p0) => '');
    return g(data);
  }

  _delegate() =>
      const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180);

  Widget _productCardItem({String? category, String? name, dynamic price, required product}) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: solidRadiusBoxDecoration(),
      child: InkWell(
        onTap: () => onAddToCartView(product, onAddToCart),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
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
      ),
    );
  }
}
