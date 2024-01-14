import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/helpers/util.dart';

var prepareGetRemoteCashSales = (
    {required startAt,
    required size,
    required String filterBy,
    required String filterValue}) {
  url(app) => '${shopFunctionsURL(app)}/sale/cash?'
      'size=$size&startAt=$startAt&filterBy=$filterBy&filterValue=$filterValue';
  beList(invoices) => itOrEmptyArray(invoices);
  return composeAsync([beList, httpGetRequest,url, shopToApp]);
};

var prepareCashRefund = (id, data) {
  var patchRequest = prepareHttpPatchRequest(data);
  url(app) => '${shopFunctionsURL(app)}/sale/cash/$id/refund';
  return composeAsync([patchRequest,url, shopToApp]);
};
