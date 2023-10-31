import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

var requestStockReportSummary = composeAsync([
  (app) => httpGetRequest('${shopFunctionsURL(app)}/stock/report/index'),
  shopToApp,
]);
