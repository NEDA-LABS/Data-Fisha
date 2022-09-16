import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

var prepareGetRemoteCashSales = (startAt, size, product, username) {
  url(app) => '${shopFunctionsURL(app)}/sale/cash?'
      'size=$size&startAt=$startAt&product=$product&username=$username';
  rFactory(app) => () => getRequest(url(app));
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
