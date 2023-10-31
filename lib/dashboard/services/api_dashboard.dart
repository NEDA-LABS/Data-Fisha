import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

getDashboardSummary(shop, date) {
  var request = composeAsync([
    (app) => httpGetRequest('${shopFunctionsURL(app)}/report/dashboard?date=$date'),
    shopToApp,
  ]);
  return request(shop);
}
