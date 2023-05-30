import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:builders/builders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/plugins/js_helper.dart';

var baseUrl = 'https://smartstock-faas.bfast.fahamutech.com';

navigateTo(String route) => Modular.to.navigate(route);

IModularNavigator navigator() => Modular.to;

navigateToAndReplace(String route) => Modular.to.pushReplacementNamed(route);

T getState<T extends Object>() => Modular.get<T>();

Widget consumerComponent<T extends ChangeNotifier>({
  required Widget Function(BuildContext context, T? state) builder,
}) =>
    Consumer<T>(builder: builder);

selectorComponent<T extends ChangeNotifier, D>({
  required Function(T state) selector,
  required Widget Function(BuildContext context, D? value) builder,
}) =>
    Selector<T, D>(builder: builder, selector: selector as D Function(T?));

String shopDatabaseURL(App app) =>
    '$baseUrl/shop/${app.projectId}/${app.applicationId}/v2';

String shopFunctionsURL(App app) =>
    '$baseUrl/shop/${app.projectId}/${app.applicationId}';

shopToApp(x) =>
    App(applicationId: x['applicationId'], projectId: x['projectId']);

var itOrEmptyArray = ifDoElse((x) => x is List, (x) => x, (_) => []);

getStockQuantity({stock}) {
  if (stock == null) return 0;
  if (stock is Map && stock['quantity'] is Map) {
    Map quantity = stock['quantity'] as Map;
    try {
      return quantity.values.map((e) => e['q']).reduce((a, b) => a + b);
    } catch (a123) {
      // print(_123);
      return 0;
    }
  }
  if (stock is Map) return stock['quantity'];
  return 0;
}

const _maxSmallScreen = 680;
const _maxMediumScreen = 1000;
// const MAX_LARGE_SCREEN = > 1008

bool getIsSmallScreen(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return width <= _maxSmallScreen;
}

bool hasEnoughWidth(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return width >= _maxMediumScreen;
}

and(List<Function> fns) => fns.fold(true, (dynamic a, b) => a && b() == true);

propertyOr(String property, Function(dynamic) onOr) => ifDoElse(
    (x) => x is Map && x.containsKey(property), (x) => x[property], onOr);

propertyOrNull(String property) => propertyOr(property, (p0) => null);

isNativeMobilePlatform() =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

isWebMobilePlatform() =>
    kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

Future<bool> isOfflineFirstEnv() async {
  var a = await JSHelper().callHasDirectPosPrinterAPI();
  if (a == true) {
    return true;
  }
  return kIsWeb == true && isWebMobilePlatform() == false;
}

var doubleOrZero = compose([
  (x) => (double.tryParse('$x') ?? 0),
  (x) => x.toStringAsFixed(5),
  (x) => (double.tryParse('$x') ?? 0)
]);

var doubleOr = (x, double or) => doubleOrZero(x) > 0 ? doubleOrZero(x) : or;

var maximumBodyWidth = 790.0;
var chartCardMobileHeight = 220.0;
var chartCardDesktopHeight = 365.0;

compactNumber(value) =>
    NumberFormat.compactCurrency(decimalDigits: 2, symbol: '')
        .format(doubleOrZero(value));

formatNumber(value, {decimals = 0}) =>
    NumberFormat.currency(decimalDigits: decimals, symbol: '')
        .format(doubleOrZero(value));

List<List<T>> divideList<T>(List<T> list, int length) {
  var len = list.length;
  var size = length;
  List<List<T>> chunks = [];
  for (var i = 0; i < len; i += size) {
    var end = (i + size < len) ? i + size : len;
    chunks.add(list.sublist(i, end));
  }
  return chunks;
}

typedef OnChangePage = Function(Widget page);
typedef OnChangeRightDrawer = Function(Widget? drawer);
typedef OnBackPage = Function();
typedef OnGetModulesMenu = List<ModuleMenu> Function({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
  required OnChangeRightDrawer onChangeRightDrawer,
});

typedef OnDoneSelectShop =  Function(Map user);
