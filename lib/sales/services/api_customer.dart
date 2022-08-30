import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_allRemoteCustomersHttpRequest(url) => get(Uri.parse(url));

_createCustomerHttpRequest(customer) => (url) => put(
      Uri.parse(url),
      headers: getInitialHeaders(),
      body: jsonEncode(customer),
    );

_createCustomer(customer) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      _createCustomerHttpRequest(customer)
    ]);

var _allRemoteCustomers = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteCustomersHttpRequest,
]);

var getAllRemoteCustomers = composeAsync([
  (customers) => itOrEmptyArray(customers),
  (app) => executeHttp(
      () => _allRemoteCustomers('${shopFunctionsURL(app)}/sale/customers')),
  map(shopToApp),
]);

createCustomer(Map customer) {
  var createRequest = _createCustomer(customer);
  f(app) => (createRequest('${shopFunctionsURL(app)}/sale/customers'));
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}
