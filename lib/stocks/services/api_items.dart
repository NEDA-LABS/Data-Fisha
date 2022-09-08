import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';
import 'package:smartstock/core/services/util.dart';

_allRemoteItemsHttpRequest(url) => get(Uri.parse(url));

_createItemHttpRequest(item) => (url) => put(
      Uri.parse(url),
      headers: getInitialHeaders(),
      body: jsonEncode(item),
    );

_createItem(item) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      _createItemHttpRequest(item)
    ]);

var _allRemoteItems = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteItemsHttpRequest,
]);

var getAllRemoteItems = composeAsync([
  (items) => itOrEmptyArray(items),
  (app) => executeHttp(
      () => _allRemoteItems('${shopFunctionsURL(app)}/stock/items')),
  map(shopToApp),
]);

createItem(Map item) {
  var createRequest = _createItem(item);
  return composeAsync([
    (app) => executeHttp(
        () => (createRequest('${shopFunctionsURL(app)}/stock/items'))),
    map(shopToApp)
  ]);
}
