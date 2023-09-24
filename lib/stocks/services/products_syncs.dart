import 'dart:convert';
import 'dart:typed_data';

import 'package:bfast/model/raw_response.dart';
import 'package:crypto/crypto.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_stocks.dart';
import 'package:smartstock/core/services/util.dart';

Future<String> _getProductsHash() async {
  var shop = await getActiveShop();
  var products = await getLocalStocks(shopToApp(shop));
  if (products is List) {
    // Encode the string as UTF-8 bytes
    var l = products
        .map((e) => DateTime.parse(e['updatedAt'] ?? '2022-01-01')
        .millisecondsSinceEpoch)
        .toList();
    l.sort((a, b) => a-b);
    var data = jsonEncode(l);
    Uint8List utf8Data = Uint8List.fromList(utf8.encode(data));
    // Calculate the SHA-1 hash
    Digest sha1Digest = sha1.convert(utf8Data);
    // Convert the SHA-1 hash to a hexadecimal string
    String sha1Hex = sha1Digest.toString();
    return sha1Hex;
  } else {
    return '-1';
  }
}

Future<bool> shouldSync() async {
  var shop = await getActiveShop();
  var baseUrl = shopFunctionsURL(shopToApp(shop));
  var hash = await _getProductsHash();
  RawResponse response = await httpGetRequest('$baseUrl/stock/sync/products?hash=$hash');
  if(response.statusCode==200){
    var body = jsonDecode(response.body);
    return body is Map && body['a'] == 1;
  }
  return false;
}
