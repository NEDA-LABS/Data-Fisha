import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

navigateTo(String route) => Modular.to.navigate(route);

IModularNavigator navigator() => Modular.to;

navigateToAndReplace(String route) => Modular.to.pushReplacementNamed(route);

T getState<T>() => Modular.get<T>();

Widget consumerComponent<T extends ChangeNotifier>({
  Widget Function(BuildContext context, T state) builder,
}) =>
    Consumer<T>(builder: builder);

selectorComponent<T extends ChangeNotifier, D>({
  Function(T state) selector,
  Widget Function(BuildContext context, D value) builder,
}) =>
    Selector<T, D>(builder: builder, selector: selector);

String shopDatabaseURL(App app) =>
    'https://smartstock-faas.bfast.fahamutech.com/shop/${app?.projectId}/${app?.applicationId}/v2';

String shopFunctionsURL(App app) =>
    'https://smartstock-faas.bfast.fahamutech.com/shop/${app?.projectId}/${app?.applicationId}';

shopToApp(x) =>
    App(applicationId: x['applicationId'], projectId: x['projectId']);

var itOrEmptyArray = ifDoElse((x) => x is List, (x) => x, (_) => []);

getStockQuantity({Map<String, dynamic> stock}) {
  if (stock == null) return 0;
  if (stock['quantity'] is int) return stock['quantity'];
  if (stock['quantity'] != null) {
    Map quantity = stock['quantity'] as Map;
    try {
      return quantity.values.map((e) => e['q']).reduce((a, b) => a + b);
    } catch (a123) {
      // print(_123);
      return 0;
    }
  }
  return 0;
}

const _maxSmallScreen = 640;
const _maxMediumScreen = 1000;
// const MAX_LARGE_SCREEN = > 1008

bool isSmallScreen(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return width <= _maxSmallScreen;
}

bool hasEnoughWidth(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return width >= _maxMediumScreen;
}

and(List<Function> fns) => fns.fold(true, (a, b) => a && b() == true);

propertyOr(String property, Function(dynamic) onOr)=>
        ifDoElse((x) => x is Map && x.containsKey(property), (x)=>x[property], onOr);
