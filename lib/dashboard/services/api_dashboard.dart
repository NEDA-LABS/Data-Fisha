import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/helpers/util.dart';

getDashboardSummary(shop, date) {
  var request = composeAsync([
    (app) => httpGetRequest('${shopFunctionsURL(app)}/report/dashboard?date=$date'),
    shopToApp,
  ]);
  return request(shop);
}
