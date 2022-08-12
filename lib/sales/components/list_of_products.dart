import 'package:flutter/material.dart';

import '../../common/util.dart';
import '../models/cart.model.dart';
import '../states/cart.state.dart';
import '../states/sales.state.dart';
import 'cart.component.dart';
import 'retail.component.dart';

Widget get _showProductLoading {
  return Container(
    color: Colors.white,
    child: Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/data.png',
            height: 150,
            width: 150,
          ),
          CircularProgressIndicator(),
          Container(
            height: 20,
          ),
          Text(
            "Fetching products",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    ),
  );
}

Widget listOfProducts({wholesale = false}) => consumerComponent<SalesState>(
      builder: (context, salesState) => salesState.loadProductsProgress
          ? _showProductLoading
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 100),
              itemCount: salesState.stocks.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        getState<CartState>().setCurrentCartToBeAdded(CartModel(
                          product: salesState.stocks[index],
                          quantity: 1,
                        ));
                        CartComponents().addToCartSheet(
                          context: context,
                          wholesale: wholesale,
                        );
                      },
                      child: RetailComponents().productCardItem(
                          productCategory:
                              salesState.stocks[index]['category'].toString(),
                          productName:
                              salesState.stocks[index]['product'].toString(),
                          productPrice: salesState.stocks[index]
                              [wholesale ? "wholesalePrice" : 'retailPrice']),
                    );
                  },
                );
              },
            ),
    );
