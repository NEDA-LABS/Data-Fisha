import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/helpers/util.dart';

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
      itemCount: itOrEmptyArray(products).length, //+1,
      shrinkWrap: true,
      gridDelegate: _delegate(),
      itemBuilder: (context, index) {
        // todo: implement add product after showing all available products
        // if(index==itOrEmptyArray(products).length){
        //   return Container(child: BodyLarge(text: 'Hi,',),);
        // }
        return _productCardItem(
            product: products[index],
            category: _getCategory(products[index]),
            name: _getName(products[index]),
            price: onGetPrice(products[index]),
            context: context);
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

  Widget _productCardItem(
      {String? category,
      String? name,
      dynamic price,
      required product,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: solidRadiusBoxDecoration(context),
      child: InkWell(
        onTap: () => onAddToCartView(product, onAddToCart),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: FittedBox(child: LabelSmall(text: category ?? ''), fit: BoxFit.scaleDown,),
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
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      price != null
                          ? NumberFormat.currency(name: 'TZS ')
                              .format(doubleOrZero(price))
                          : '',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: 14
                      ),
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
