import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

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

prepareGetRemoteInvoiceSales(
    {required String startAt, required int size, required String filterBy, required String filterValue}) {
  url(app) => '${shopFunctionsURL(app)}/sale/invoice?'
      'size=$size&startAt=$startAt&filterBy=$filterBy&filterValue=$filterValue';
  rFactory(app) => () => httpGetRequest(url(app));
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
