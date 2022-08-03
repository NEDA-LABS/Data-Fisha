import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

navigateTo(String route) => Modular.to.navigate(route);

IModularNavigator navigator() => Modular.to;

navigateToAndReplace(String route) => Modular.to.pushReplacementNamed(route);

T getState<T>() => Modular.get<T>();

consumerComponent<T extends ChangeNotifier>({
  Widget Function(BuildContext context, T state) builder,
}) =>
    Consumer<T>(builder: builder);

selectorComponent<T extends ChangeNotifier, D>({
  Function(T state) selector,
  Widget Function(BuildContext context, D value) builder,
}) =>
    Selector<T, D>(builder: builder, selector: selector);

getStockQuantity({Map<String, dynamic> stock}) {
  if (stock == null) return 0;
  if (stock['quantity'] is int) return stock['quantity'];
  if (stock['quantity'] != null) {
    Map quantity = stock['quantity'] as Map;
    try {
      return quantity.values.map((e) => e['q']).reduce((a, b) => a + b);
    } catch (_123) {
      print(_123);
      return 0;
    }
  }
  return 0;
}
//
// const baseUrl = "https://smartstock-faas.bfast.fahamutech.com/shop/";
// const headers = {'content-type': 'application/json'};
//
// responseResult(Response response, Function(dynamic d) onBody) {
//   if (response.statusCode == 200) {
//     // print(response.body);
//     return onBody(jsonDecode(response.body));
//   } else {
//     var eb = response.body;
//     var fallbackErrorString = '{"message":"unknown error, check internet"}';
//     var ebString = eb;
//     var errorString = "";
//     if (ebString.trim().startsWith("{")) {
//       errorString = ebString;
//     } else {
//       errorString = fallbackErrorString;
//     }
//     var errorModel = jsonDecode(errorString);
//     if (errorModel['message'].isNotEmpty) throw Exception(errorModel['message']);
//     if (errorModel['error_message'].isNotEmpty) {
//       throw Exception(errorModel['error_message']);
//     } else {
//       throw Exception('unknown error');
//     }
//   }
// }
