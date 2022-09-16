import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

prepareGetTransfers(String startAt) {
  return composeAsync([
    (transfers) => itOrEmptyArray(transfers),
    (app) => executeHttp(() =>
        getRequest('${shopFunctionsURL(app)}/stock/transfer?skip=0&size=50')),
    shopToApp,
  ]);
}

prepareSendTransfer(Map transfer) {
  var createRequest = preparePutRequest(transfer);
  f(app) => () => createRequest('${shopFunctionsURL(app)}/stock/transfer/send');
  return composeAsync([(app) => executeHttp(f(app)), shopToApp]);
}

prepareReceiveTransfer(Map transfer) {
  var createRequest = preparePutRequest(transfer);
  f(app) =>
      () => createRequest('${shopFunctionsURL(app)}/stock/transfer/receive');
  return composeAsync([(app) => executeHttp(f(app)), shopToApp]);
}
