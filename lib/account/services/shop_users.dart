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

Future updateUserPassword(userId, password) async {
  var shop = await getActiveShop();
  return updateShopUserPasswordRemote(shop, userId, password);
}

Future deleteUser(userId) async {
  var shop = await getActiveShop();
  return deleteShopUserRemote(shop, userId);
}
