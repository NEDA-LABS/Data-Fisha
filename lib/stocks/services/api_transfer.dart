import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

prepareGetTransfers(String startAt) {
  return composeAsync([
    itOrEmptyArray,
    (app) => httpGetRequest(
        '${shopFunctionsURL(app)}/stock/transfer?size=50&start=$startAt'),
    shopToApp,
  ]);
}

prepareSendTransfer(Map transfer) {
  var createRequest = prepareHttpPutRequest(transfer);
  f(app) => createRequest('${shopFunctionsURL(app)}/stock/transfer/send');
  return composeAsync([f,shopToApp]);
}

prepareReceiveTransfer(Map transfer) {
  var createRequest = prepareHttpPutRequest(transfer);
  f(app) => createRequest('${shopFunctionsURL(app)}/stock/transfer/receive');
  return composeAsync([f,shopToApp]);
}
