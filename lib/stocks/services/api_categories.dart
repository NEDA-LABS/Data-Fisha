import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_allRemoteCategoriesHttpRequest(url) => get(Uri.parse(url));

_createCategoryHttpRequest(category) => (url) => post(
      Uri.parse(url),
      headers: getInitialHeaders(),
      body: jsonEncode(category),
    );

_createCategory(category) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      _createCategoryHttpRequest(category)
    ]);

var _allRemoteCategories = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteCategoriesHttpRequest,
]);

var getAllRemoteCategories = composeAsync([
  (categories) => itOrEmptyArray(categories),
  (app) => executeHttp(
      () => _allRemoteCategories('${shopFunctionsURL(app)}/stock/categories')),
  map(shopToApp),
]);

createCategory(Map category) {
  var createRequest = _createCategory(category);
  return composeAsync([
    (app) => executeHttp(
        () => (createRequest('${shopFunctionsURL(app)}/stock/categories'))),
    map(shopToApp)
  ]);
}
