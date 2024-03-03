import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future<List> productSuppliersRestAPI(Map shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/suppliers';
  var httpGetRequest = prepareHttpGetRequest();
  var suppliers = await httpGetRequest(url);
  return itOrEmptyArray(suppliers);
}

productCreateSupplierRestAPI(Map supplier, Map shop) {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/suppliers';
  var httpPutRequest = prepareHttpPutRequest(supplier);
  return httpPutRequest(url);
}

Future Function(dynamic shop) prepareDeleteSupplierAPI(id) {
  var httpDeleteRequest = prepareHttpDeleteRequest({});
  return composeAsync([
    httpDeleteRequest,
        (app) => '${shopFunctionsURL(app)}/stock/suppliers/$id',
    shopToApp
  ]);
}


Future Function(dynamic shop) prepareUpdateSupplierAPI(id,Map category) {
  var httpPutRequest = prepareHttpPutRequest(category);
  return composeAsync([
    httpPutRequest,
        (app) => '${shopFunctionsURL(app)}/stock/suppliers/$id',
    shopToApp
  ]);
}