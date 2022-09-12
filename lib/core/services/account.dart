import 'package:smartstock/core/services/api_account.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';

Future accountLogin(String username, String password) async {
  var user = await accountRemoteLogin(username.trim(), password.trim());
  await setLocalCurrentUser(user);
  if (user != null) {
    return user;
  } else {
    throw "User is null";
  }
}

logOut() {
  removeActiveShop();
  removeLocalCurrentUser();
  navigateToAndReplace('/');
}