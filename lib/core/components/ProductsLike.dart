import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/types/OnAddToCart.dart';
import 'package:smartstock/core/types/OnAddToCartView.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';

class ProductsLike extends StatelessWidget {
  final List<dynamic> products;
  final OnAddToCartSubmitCallback onAddToCart;
  final OnGetPrice onGetPrice;
  final OnAddToCart onAddToCartView;

  const ProductsLike({
    required this.products,
    required this.onAddToCart,
    required this.onGetPrice,
    required this.onAddToCartView,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
      itemCount: itOrEmptyArray(products).length,
      shrinkWrap: true,
      gridDelegate: _delegate(),
      // todo: implement add product after showing all available products
      // if(index==itOrEmptyArray(products).length){
      //   return Container(child: BodyLarge(text: 'Hi,',),);
      // }
      itemBuilder: _productCardItem,
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

  _delegate() {
    return const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180);
  }

  Widget _productCardItem(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: solidRadiusBoxDecoration(context),
      child: InkWell(
        onTap: () => onAddToCartView(products[index], onAddToCart),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LabelSmall(text: _getCategory(products[index]) ?? ''),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    _getName(products[index]) ?? '',
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
                      onGetPrice(products[index]) != null
                          ? formatNumber(onGetPrice(products[index]))
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
