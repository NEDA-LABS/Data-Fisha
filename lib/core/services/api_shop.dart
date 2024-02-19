import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/helpers/util.dart';

var _lastSig = '';

_sha1e(dynamic data) {
  return '${sha1.convert(
    utf8.encode(jsonEncode(data)),
  )}';
}

Future updateShopLocation(
    {required String latitude, required String longitude}) async {
  var data = {'longitude': longitude, 'latitude': latitude};
  var sig = _sha1e(data);
  if(_lastSig==sig){
    if (kDebugMode) {
      print('Same location update');
    }
    return [];
  }
  var shop = await getActiveShop();
  var user = await getLocalCurrentUser();
  var patchShopLocation = prepareHttpPatchRequest(data);
  var url =
      '$baseUrl/account/${user?['id'] ?? '-1'}/shops/${shop?['projectId'] ?? '-1'}/location';
  var res = await patchShopLocation(url);
  _lastSig = sig;
  return res;
}
