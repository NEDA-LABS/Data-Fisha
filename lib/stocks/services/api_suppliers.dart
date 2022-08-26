import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_allRemoteSuppliersHttpRequest(url) => get(Uri.parse(url));

_createSupplierHttpRequest(supplier) => (url) => put(
  Uri.parse(url),
  headers: getInitialHeaders(),
  body: jsonEncode(supplier),
);

_createSupplier(supplier) => composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _createSupplierHttpRequest(supplier)
]);

var _allRemoteSuppliers = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteSuppliersHttpRequest,
]);

var getAllRemoteSuppliers = composeAsync([
  (suppliers) => itOrEmptyArray(suppliers),
  (app) => executeHttp(
      () => _allRemoteSuppliers('${shopFunctionsURL(app)}/stock/suppliers')),
  map(shopToApp),
]);

createSupplier(Map supplier) {
  var createRequest = _createSupplier(supplier);
  return composeAsync([
        (app) => executeHttp(
            () => (createRequest('${shopFunctionsURL(app)}/stock/suppliers'))),
    map(shopToApp)
  ]);
}