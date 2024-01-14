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
