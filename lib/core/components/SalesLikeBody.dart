// import 'package:flutter/material.dart';
// import 'package:smartstock/core/components/PrimaryAction.dart';
// import 'package:smartstock/core/components/ProductsLike.dart';
// import 'package:smartstock/core/helpers/util.dart';
// import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
// import 'package:smartstock/core/types/OnAddToCart.dart';
// import 'package:smartstock/core/types/OnGetPrice.dart';
//
// class SalesLikeBody extends StatelessWidget {
//   final List products;
//   final List carts;
//   final bool wholesale;
//   final OnAddToCartSubmitCallback onAddToCart;
//   final VoidCallback onShowCart;
//   final OnAddToCart onAddToCartView;
//   final OnGetPrice onGetPrice;
//
//   const SalesLikeBody({
//     required this.products,
//     this.carts = const [],
//     this.wholesale = false,
//     required this.onAddToCart,
//     required this.onShowCart,
//     required this.onAddToCartView,
//     required this.onGetPrice,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Positioned(
//         top: 0,
//         bottom: 0,
//         left: 0,
//         right: 0,
//         child: ProductsLike(
//           onAddToCart: onAddToCart,
//           products: products,
//           onAddToCartView: onAddToCartView,
//           onGetPrice: onGetPrice,
//         ),
//       ),
//       hasEnoughWidth(context)
//           ? const Positioned(left: 0, child: SizedBox(height: 0))
//           : Positioned(
//               bottom: 16, left: 16, right: 16, child: _cartPreview(context))
//     ]);
//   }
//
//   Widget _cartPreview(BuildContext context) {
//     return carts.isNotEmpty
//         ? PrimaryAction(
//             text: 'Cart [ ${_getTotalItems(carts)} Items ]',
//             onPressed: onShowCart)
//         : const SizedBox(width: 0, height: 0);
//   }
//
//   _getTotalItems(List<dynamic> carts) {
//     return carts.fold(0, (dynamic a, element) => a + element.quantity);
//   }
// }
