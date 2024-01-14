import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future salesCustomersRestAPI(Map shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/sale/customers';
  var httpGetRequest = prepareHttpGetRequest();
  var customers = await httpGetRequest(url);
  return itOrEmptyArray(customers);
}

salesCreateCustomerRestAPI(Map customer, Map shop) {
  var url = '${shopFunctionsURL(shopToApp(shop))}/sale/customers';
  var httpPutRequest = prepareHttpPutRequest(customer);
  return httpPutRequest(url);
}
