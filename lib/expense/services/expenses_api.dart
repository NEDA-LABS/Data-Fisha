import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

var prepareGetRemoteExpenses = (startAt, size, query) {
  url(app) =>
      '${shopFunctionsURL(app)}/expense?size=$size&startAt=$startAt&q=$query';
  rFactory(app) => () => getRequest(url(app));
  request(app) => executeHttp(rFactory(app));
  beList(invoices) => itOrEmptyArray(invoices);
  return composeAsync([beList, request, shopToApp]);
};


