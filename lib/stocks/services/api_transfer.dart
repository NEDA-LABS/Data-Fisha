import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

_preparePutRequest(transfer) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      preparePutRequest(transfer)
    ]);

// _preparePatchRequest(body) => composeAsync([
//       map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
//       preparePatchRequest(body)
//     ]);

var _getRequest = composeAsync([
  (x) => RawResponse(body: x.body, statusCode: x.statusCode),
  getRequest,
]);

var prepareGetTransfers = (String startAt) => composeAsync([
      (transfers) => itOrEmptyArray(transfers),
      (app) => executeHttp(() => _getRequest(
          '${shopFunctionsURL(app)}/stock/transfer?skip=0&size=50')),
      map(shopToApp),
    ]);

// preparePatchTransferPayment(String? id, Map payment) {
//   var patchInvoice = _preparePatchRequest(payment);
//   f(app) => () => patchInvoice('${shopFunctionsURL(app)}/stock/transfer/$id');
//   return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
// }

prepareSendTransfer(Map transfer) {
  var createRequest = _preparePutRequest(transfer);
  f(app) => () => createRequest('${shopFunctionsURL(app)}/stock/transfer/send');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}

prepareReceiveTransfer(Map transfer) {
  var createRequest = _preparePutRequest(transfer);
  f(app) =>
      () => createRequest('${shopFunctionsURL(app)}/stock/transfer/receive');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}
