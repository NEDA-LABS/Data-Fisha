import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

// _allRemoteInvoicesHttpRequest(url) => get(Uri.parse(url));
//
// _createInvoiceHttpRequest(invoice) => (url) => put(
//       Uri.parse(url),
//       headers: getInitialHeaders(),
//       body: jsonEncode(invoice),
//     );
// _patchInvoiceHttpRequest(payment) => (url) => patch(
//       Uri.parse(url),
//       headers: getInitialHeaders(),
//       body: jsonEncode(payment),
//     );
//
// _createInvoice(invoice) => composeAsync([
//       map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
//       _createInvoiceHttpRequest(invoice)
//     ]);

// _patchInvoice(invoice) => composeAsync([
//   map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
//   _patchInvoiceHttpRequest(invoice)
// ]);
//
// var _allRemoteInvoices = composeAsync([
//   map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
//   _allRemoteInvoicesHttpRequest,
// ]);

// var getAllRemoteInvoices = (String date) => composeAsync([
//   (invoices) => itOrEmptyArray(invoices),
//   (app) => executeHttp(
//       () => _allRemoteInvoices('${shopFunctionsURL(app)}/sale/invoice?date=$date&size=50')),
//   map(shopToApp),
// ]);

prepareCreateInvoice(Map invoice) {
  var createRequest = preparePostRequest(invoice);
  f(app) => () => createRequest('${shopFunctionsURL(app)}/sale/invoice');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}

prepareAddInvoicePayment(String? id, Map payment) {
  var patchInvoice = preparePatchRequest(payment);
  f(app) =>
      () => patchInvoice('${shopFunctionsURL(app)}/sale/invoice/$id/payment');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}

prepareGetRemoteInvoiceSales(startAt, size, product, username) {
  url(app) => '${shopFunctionsURL(app)}/sale/invoice?'
      'size=$size&startAt=$startAt&product=$product&username=$username';
  rFactory(app) => () => getRequest(url(app));
  request(app) => executeHttp(rFactory(app));
  beList(invoices) => itOrEmptyArray(invoices);
  return composeAsync([beList, request, shopToApp]);
}

prepareInvoiceRefund(id, data) {
  var patchRequest = preparePatchRequest(data);
  url(app) => '${shopFunctionsURL(app)}/sale/invoice/$id/refund';
  rFactory(app) => () => patchRequest(url(app));
  request(app) => executeHttp(rFactory(app));
  return composeAsync([request, shopToApp]);
}
