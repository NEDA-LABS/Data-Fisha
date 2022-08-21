import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_allRemoteSuppliersHttpRequest(url) => get(Uri.parse(url));

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
