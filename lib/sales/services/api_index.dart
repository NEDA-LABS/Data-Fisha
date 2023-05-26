import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

getSalesSummaryReport(shop, date) {
  var request = composeAsync(
    [
      (app) => executeHttp(
            () => httpGetRequest(
              '${shopFunctionsURL(app)}/report/sales/dashboard?from=$date&to=$date',
            ),
          ),
      shopToApp,
    ],
  );
  return request(shop);
}
