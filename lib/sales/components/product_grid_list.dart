// import 'package:flutter/material.dart';
// import 'package:smartstock/sales/components/product_card.dart';
//
// import '../../core/services/util.dart';
// import '../models/cart.model.dart';
// import '../states/cart.dart';
// import '../states/index.dart';
// import 'cart.dart';
// import 'loading_view.dart';
//
// Widget listOfProducts({wholesale = false}) =>
//     selectorComponent<SalesState, bool>(
//       selector: (state) => state.loadProductsProgress,
//       builder: (context, value) => value
//           ? showProductLoading()
//           : _productsGridList(wholesale: wholesale),
//     );
//
// Widget _productsGridList({bool wholesale}) =>
//     selectorComponent<SalesState, List>(
//         selector: (state) => state.stocks,
//         builder: (context, stocks) => GridView.builder(
//               padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
//               itemCount: stocks.length,
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 50.0,
//                 mainAxisExtent: 50,
//               ),
//               itemBuilder: (context, index) => _item(
//                 stocks: stocks,
//                 index: index,
//                 wholesale: wholesale,
//               ),
//             ));
//
// Widget _item({List stocks, int index, bool wholesale}) => Builder(
//       builder: (context) {
//         return GestureDetector(
//           onTap: () {
//             getState<CartState>().setCurrentCartToBeAdded(
//               CartModel(
//                 product: stocks[index],
//                 quantity: 1,
//               ),
//             );
//             addToCartSheet(context: context, wholesale: wholesale);
//           },
//           child: productCardItem(
//               productCategory: stocks[index]['category'],
//               productName: stocks[index]['product'],
//               productPrice: stocks[index]
//                   [wholesale ? "wholesalePrice" : 'retailPrice']),
//         );
//       },
//     );
