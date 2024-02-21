import 'dart:async';

import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future productTransfersFindAPI(
    {required String startAt, required Map shop}) async {
  var app = shopToApp(shop);
  var response = await httpGetRequest(
      '${shopFunctionsURL(app)}/stock/transfer?size=50&start=$startAt');
  return itOrEmptyArray(response);
}

Future productTransferSendCreateAPI(
    {required Map transfer, required Map shop}) async {
  var app = shopToApp(shop);
  var createRequest = prepareHttpPutRequest(transfer);
  var response =
      await createRequest('${shopFunctionsURL(app)}/stock/transfer/send');
  return response;
}

Future productTransferReceiveCreateAPI(
    {required Map transfer, required Map shop}) async {
  var app = shopToApp(shop);
  var createRequest = prepareHttpPutRequest(transfer);
  var response =
      await createRequest('${shopFunctionsURL(app)}/stock/transfer/receive');
  return response;
}
