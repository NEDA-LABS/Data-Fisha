import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';
import 'package:smartstock/core/services/util.dart';


_allRemoteProductsHttpRequest(url) => get(
      Uri.parse(url),
      // headers: getInitialHeaders(),
      // body: jsonEncode({"hashes": []}),
    );

var _allRemoteProducts = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteProductsHttpRequest,
]);

var getAllRemoteStocks = composeAsync([
  (products) => itOrEmptyArray(products),
  (app) => executeHttp(
      () => _allRemoteProducts('${shopFunctionsURL(app)}/stock/products')),
  map(shopToApp),
]);
