// import 'package:flutter/material.dart';
// import 'package:smartstock_pos/core/components/active_component.dart';
// import 'package:smartstock_pos/core/services/stocks.dart';
// import 'package:smartstock_pos/core/services/util.dart';
// import 'package:smartstock_pos/sales/components/refresh_button.dart';
// import 'package:smartstock_pos/sales/services/cart.dart';
//
// import '../../app.dart';
// import '../../core/components/responsive_body.dart';
// import '../../core/components/top_bar.dart';
// import '../components/cart_drawer.dart';
// import '../components/sales_body.dart';
//
// class WholesalePage extends StatelessWidget {
//   WholesalePage({Key key}) : super(key: key);
//
//   final _getSkip = propertyOr('skip', (p0) => false);
//   final _getQuery = propertyOr('query', (p0) => '');
//   final _getCarts = propertyOr('carts', (p0) => []);
//   final _getCustomer = propertyOr('customer', (p0) => '');
//
//   _hasCarts(states) => _getCarts(states).length > 0;
//
//   _future(states) => getStockFromCacheOrRemote(
//       skipLocal: _getSkip(states), stringLike: _getQuery(states));
//
//   _onAddToCart(states, updateState) => (cart) {
//     var carts = appendToCarts(cart, _getCarts(states));
//     updateState({"carts": carts, 'query': ''});
//     navigator().maybePop();
//   };
//
//   _onShowCheckoutSheet(states, updateState, context) => () {
//     updateState({'hab': true});
//     showModalBottomSheet(
//       isScrollControlled: true,
//       enableDrag: true,
//       context: context,
//       builder: (context) => cartDrawer(
//           carts: _getCarts(states),
//           wholesale: true,
//           context: context,
//           customer: _getCustomer(states),
//           onCustomer: (d) => updateState({"customer": d})),
//     ).whenComplete(() => updateState({'hab': false}));
//   };
//
//   _appBar(updateState) => StockAppBar(
//       title: "Wholesale",
//       backLink: "/sales/",
//       showBack: true,
//       showSearch: true,
//       searchHint: "Search here...",
//       onSearch: (text) {
//         updateState({"query": text, 'skip': false});
//       });
//
//   _fab(states, updateState) => salesRefreshButton(
//       onPressed: () => updateState({"skip": true}),
//       carts: states['carts'] ?? []);
//
//   _isLoading(snapshot) =>
//       snapshot is AsyncSnapshot &&
//           snapshot.connectionState == ConnectionState.waiting;
//
//   _getView(carts, onAddToCart, onShowCheckout) =>
//           (context, snapshot) => Column(children: [
//         _isLoading(snapshot)
//             ? const LinearProgressIndicator()
//             : const SizedBox(height: 0),
//         Expanded(
//             child: salesBody(
//                 wholesale: true,
//                 products: snapshot.data ?? [],
//                 onAddToCart: onAddToCart,
//                 onShowCheckout: onShowCheckout,
//                 carts: carts,
//                 context: context))
//       ]);
//
//   @override
//   Widget build(var context) => ActiveComponent(
//       initialState: const {'skip': false, 'query': ''},
//       builder: (context, states, updateState) => responsiveBody(
//           menus: moduleMenus(),
//           office: 'Menu',
//           current: '/sales/',
//           rightDrawer: _hasCarts(states)
//               ? SizedBox(
//             width: 350,
//             child: cartDrawer(
//               carts: _getCarts(states),
//               wholesale: true,
//               context: context,
//               customer: _getCustomer(states),
//               onCustomer: (d) => updateState({"customer": d}),
//             ),
//           )
//               : null,
//           onBody: (drawer) => Scaffold(
//               appBar: states['hab'] == true ? null : _appBar(updateState),
//               floatingActionButton: _fab(states, updateState),
//               body: FutureBuilder(
//                   initialData: _getCarts(states),
//                   future: _future(states),
//                   builder: _getView(
//                       _getCarts(states),
//                       _onAddToCart(states, updateState),
//                       _onShowCheckoutSheet(states, updateState, context))))));
// }
