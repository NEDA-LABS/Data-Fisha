import 'package:bfast/util.dart';
import 'package:flutter/services.dart';

import 'cache_shop.dart';
import 'util.dart';

var _getShopSettings =
    propertyOr('settings', (p0) => {'saleWithoutPrinter': false});
var _getMustPrint = compose(
    [propertyOr('saleWithoutPrinter', (p0) => false), _getShopSettings]);
var _getPrinterHeader = compose(
    [propertyOr('printerHeader', (p0) => '\n'), _getShopSettings]);
var _getPrinterFooter = compose(
    [propertyOr('printerFooter', (p0) => '\n'), _getShopSettings]);

Future<String> posPrint({String data, String qr}) async {
  var currentShop = await getActiveShop();
  if (_getMustPrint(currentShop) == false) {
    var header = _getPrinterHeader(currentShop);
    var footer = _getPrinterFooter(currentShop);
   data = '$header \n $data \n $footer';
// await Future.delayed(const Duration(seconds: 3));
    // return await const MethodChannel('com.smartstock/printer').invokeMethod(
    //     'print', {"data": data, "printer": 'printer', "id": 'id', "qr": ''});
  }
  return "done printing";
}
