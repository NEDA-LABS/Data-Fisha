import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_allRemoteInvoicesHttpRequest(url) => get(Uri.parse(url));

_createInvoiceHttpRequest(invoice) => (url) => put(
      Uri.parse(url),
      headers: getInitialHeaders(),
      body: jsonEncode(invoice),
    );
_patchInvoiceHttpRequest(payment) => (url) => patch(
      Uri.parse(url),
      headers: getInitialHeaders(),
      body: jsonEncode(payment),
    );

_createInvoice(invoice) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      _createInvoiceHttpRequest(invoice)
    ]);

_patchInvoice(invoice) => composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _patchInvoiceHttpRequest(invoice)
]);

var _allRemoteInvoices = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteInvoicesHttpRequest,
]);

var getAllRemoteInvoices = (String date) => composeAsync([
  (invoices) => itOrEmptyArray(invoices),
  (app) => executeHttp(
      () => _allRemoteInvoices('${shopFunctionsURL(app)}/sale/invoice?date=$date&size=50')),
  map(shopToApp),
]);

prepareCreateInvoice(Map invoice) {
  var createRequest = _createInvoice(invoice);
  f(app) => () => createRequest('${shopFunctionsURL(app)}/sale/invoice');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}


prepareAddPayment(String id, Map payment) {
  var patchInvoice = _patchInvoice(payment);
  f(app) => () => patchInvoice('${shopFunctionsURL(app)}/sale/invoice/$id');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}