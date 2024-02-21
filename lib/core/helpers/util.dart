import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/plugins/js_helper.dart';

firstLetterUpperCase(x) {
  if(x is String && x.isNotEmpty){
    var first = x.split('').first;
    var other = x.substring(1);
    return first.toUpperCase() + other;
  }
  return x??'';
}

//'http://localhost:3000'; //
var baseUrl = 'https://smartstock-faas.bfast.fahamutech.com';

String shopFunctionsURL(App app) =>
    '$baseUrl/shop/${app.projectId}/${app.applicationId}';

shopToApp(x) =>
    App(applicationId: x['applicationId'], projectId: x['projectId']);

List<T> itOrEmptyArray<T>(x) {
  if (x is List<T>) {
    return x;
  }
  return [];
}

List justArray(x) {
  if (x is List) {
    return x;
  }
  return [x];
}

// var itOrEmptyArray = ifDoElse((x) => x is List, (x) => x, (_) => []);

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

compactNumber(value) =>
    NumberFormat.compactCurrency(decimalDigits: 2, symbol: '')
        .format(doubleOrZero(value));

formatNumber(value, {decimals = 2}) {
  var formatted = NumberFormat.currency(decimalDigits: decimals, symbol: '')
      .format(doubleOrZero(value));
  var formattedChunks = formatted.split('.');
  if (formattedChunks.length > 1) {
    if (formattedChunks[1] == '00' || formattedChunks[1] == '0') {
      return formatted.split('.')[0];
    } else {
      return formatted;
    }
  } else {
    return formatted;
  }
}

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

typedef OnChangePage = Function(PageBase page);
typedef OnChangeRightDrawer = Function(Widget? drawer);
typedef OnBackPage = Function();
typedef OnGeAppMenu = List<ModuleMenu> Function({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
});

typedef OnGetInitialPage = PageBase? Function({
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
});

typedef OnDoneSelectShop = Function(Map user);
