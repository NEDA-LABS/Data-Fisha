import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/stocks/services/api_product.dart';

Future deleteProduct(String? id) async {
  var shop = await getActiveShop();
  var delete = prepareDeleteProduct(id);
  return delete(shop);
}
