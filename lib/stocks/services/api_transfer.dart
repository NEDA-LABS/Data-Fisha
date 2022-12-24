import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

prepareGetTransfers(String startAt) {
  return composeAsync([
    (transfers) => itOrEmptyArray(transfers),
    (app) => executeHttp(() => httpGetRequest(
        '${shopFunctionsURL(app)}/stock/transfer?size=50&start=$startAt')),
    shopToApp,
  ]);
}

prepareSendTransfer(Map transfer) {
  var createRequest = prepareHttpPutRequest(transfer);
  f(app) => () => createRequest('${shopFunctionsURL(app)}/stock/transfer/send');
  return composeAsync([(app) => executeHttp(f(app)), shopToApp]);
}

prepareReceiveTransfer(Map transfer) {
  var createRequest = prepareHttpPutRequest(transfer);
  f(app) =>
      () => createRequest('${shopFunctionsURL(app)}/stock/transfer/receive');
  return composeAsync([(app) => executeHttp(f(app)), shopToApp]);
}
