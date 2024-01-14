import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';


Future<List> productsAllRestAPI(Map shop)async{
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/products';
  var getHttpRequest = prepareHttpGetRequest();
  var products = await getHttpRequest(url);
  return itOrEmptyArray(products);
}
