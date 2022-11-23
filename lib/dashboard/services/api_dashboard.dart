import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

// _getDashSummary(url) => get(Uri.parse(url));
//
// var _getAndMap = composeAsync([
//   map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
//   _getDashSummary,
// ]);

getDashboardSummary(shop, date) {
  var request = composeAsync([
    (app) => executeHttp(() => httpGetRequest(
        '${shopFunctionsURL(app)}/report/dashboard?date=$date')),
    shopToApp,
  ]);
  return request(shop);
}
