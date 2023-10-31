import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

prepareCreateInvoice(Map invoice) {
  var createRequest = prepareHttpPostRequest(invoice);
  f(app) => createRequest('${shopFunctionsURL(app)}/sale/invoice');
  return composeAsync([f, shopToApp]);
}

prepareAddInvoicePayment(String? id, Map payment) {
  var patchInvoice = prepareHttpPatchRequest(payment);
  f(app) => patchInvoice('${shopFunctionsURL(app)}/sale/invoice/$id/payment');
  return composeAsync([f, shopToApp]);
}

prepareGetRemoteInvoiceSales(
    {required String startAt,
    required int size,
    required String filterBy,
    required String filterValue}) {
  url(app) => '${shopFunctionsURL(app)}/sale/invoice?'
      'size=$size&startAt=$startAt&filterBy=$filterBy&filterValue=$filterValue';
  return composeAsync([itOrEmptyArray, httpGetRequest, url, shopToApp]);
}

prepareInvoiceRefund(id, data) {
  var patchRequest = prepareHttpPatchRequest(data);
  url(app) => '${shopFunctionsURL(app)}/sale/invoice/$id/refund';
  return composeAsync([patchRequest, url, shopToApp]);
}
