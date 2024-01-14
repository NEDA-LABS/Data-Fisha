import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/helpers/util.dart';

Future getAllCategoriesAPI(shop) async {
  App app = shopToApp(shop);
  String url = '${shopFunctionsURL(app)}/stock/categories';
  var categories = await httpGetRequest(url);
  return itOrEmptyArray(categories);
}

Future Function(dynamic shop) prepareUpsertCategoryAPI(Map category) {
  var httpPutRequest = prepareHttpPutRequest(category);
  return composeAsync([
    httpPutRequest,
    (app) => '${shopFunctionsURL(app)}/stock/categories',
    shopToApp
  ]);
}

Future Function(dynamic shop) prepareDeleteCategoryAPI(id) {
  var httpDeleteRequest = prepareHttpDeleteRequest({});
  return composeAsync([
    httpDeleteRequest,
    (app) => '${shopFunctionsURL(app)}/stock/categories/$id',
    shopToApp
  ]);
}
