import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../models/cart.model.dart';
import '../states/cart.dart';
import '../states/sales.dart';
import 'cart.dart';
import 'product_card.dart';

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
          const CircularProgressIndicator(),
          Container(
            height: 20,
          ),
          const Text(
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
              itemCount: salesState.stocks.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        addToCartSheet(
                          context: context,
                          wholesale: wholesale,
                        );
                      },
                      child: productCardItem(
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
