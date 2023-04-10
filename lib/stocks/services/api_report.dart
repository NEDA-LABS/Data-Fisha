import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

var _getPurchases = composeAsync([
  (x) => RawResponse(body: x.body, statusCode: x.statusCode),
  httpGetRequest,
]);

var requestStockReportSummary = composeAsync([
  (app) {
    return executeHttp(
      () => _getPurchases(
        '${shopFunctionsURL(app)}/stock/report/index',
      ),
    );
  },
  shopToApp,
]);
