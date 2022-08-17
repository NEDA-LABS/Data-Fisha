import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/cart.component.dart';
import 'package:smartstock_pos/modules/sales/components/loading_view.dart';
import 'package:smartstock_pos/modules/sales/components/product_card.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';
import 'package:smartstock_pos/util.dart';

Widget listOfProducts({wholesale = false}) =>
    selectorComponent<SalesState, bool>(
      selector: (state) => state.loadProductsProgress,
      builder: (context, value) => value
          ? showProductLoading()
          : _productsGridList(wholesale: wholesale),
    );

Widget _productsGridList({bool wholesale}) =>
    selectorComponent<SalesState, List>(
        selector: (state) => state.stocks,
        builder: (context, stocks) => GridView.builder(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 100),
              itemCount: stocks.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => _item(
                stocks: stocks,
                index: index,
                wholesale: wholesale,
              ),
            ));

Widget _item({List stocks, int index, bool wholesale}) => Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            getState<CartState>().setCurrentCartToBeAdded(
              CartModel(
                product: stocks[index],
                quantity: 1,
              ),
            );
            addToCartSheet(context: context, wholesale: wholesale);
          },
          child: productCardItem(
              productCategory: stocks[index]['category'],
              productName: stocks[index]['product'],
              productPrice: stocks[index]
                  [wholesale ? "wholesalePrice" : 'retailPrice']),
        );
      },
    );
