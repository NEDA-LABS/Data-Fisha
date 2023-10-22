import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

var prepareGetRemoteCashSales = (
    {required startAt,
    required size,
    required String filterBy,
    required String filterValue}) {
  url(app) => '${shopFunctionsURL(app)}/sale/cash?'
      'size=$size&startAt=$startAt&filterBy=$filterBy&filterValue=$filterValue';
  rFactory(app) => () => httpGetRequest(url(app));
  request(app) => executeHttp(rFactory(app));
  beList(invoices) => itOrEmptyArray(invoices);
  return composeAsync([beList, request, shopToApp]);
};

var prepareCashRefund = (id, data) {
  var patchRequest = preparePatchRequest(data);
  url(app) => '${shopFunctionsURL(app)}/sale/cash/$id/refund';
  rFactory(app) => () => patchRequest(url(app));
  request(app) => executeHttp(rFactory(app));
  return composeAsync([request, shopToApp]);
};
