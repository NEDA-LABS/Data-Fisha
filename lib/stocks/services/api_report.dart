import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/helpers/util.dart';

var requestStockReportSummary = composeAsync([
  (app) => httpGetRequest('${shopFunctionsURL(app)}/stock/report/index'),
  shopToApp,
]);
