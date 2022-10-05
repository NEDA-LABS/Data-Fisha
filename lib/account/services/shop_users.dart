import 'package:smartstock/account/services/api_account.dart';
import 'package:smartstock/core/services/cache_shop.dart';

Future getShopUsers() async {
  var shop = await getActiveShop();
  return getShopUsersRemote(shop);
}

Future addShopUser(user) async {
  var shop = await getActiveShop();
  return addShopUserRemote(shop, user);
}
