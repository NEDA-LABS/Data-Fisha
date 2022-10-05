import 'package:bfast/util.dart';
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

Future accountRegister(data) async {
  var user = await accountRemoteRegister(data);
  await setLocalCurrentUser(user);
  if (user != null) {
    return user;
  } else {
    throw "User is null";
  }
}

Future accountResetPassword(username) async {
  var value = await accountRemoteReset(username);
  // await setLocalCurrentUser(user);
  if (value != null) {
    return value;
  } else {
    throw "Unexpected response";
  }
}

logOut() {
  removeActiveShop().then((value) {
    return removeLocalCurrentUser();
  }).then((value) {
    navigateToAndReplace('/account/login');
  });
}

Future<List> getUserShops() async {
  var user = await getLocalCurrentUser();
  var getShops = compose([
    (shops) {
      user['shops'] = [];
      shops.add(user);
      return shops;
    },
    propertyOr('shops', (p0) => []),
  ]);
  return getShops(user);
}

// Future getAllCurrentUserShops() async {
//   var user = await getLocalCurrentUser();
//   var shops = _getUserShops(user);
//   // user['shops'].forEach((element) {
//   //   shops.add(element);
//   // });
//   shops.add({
//     "businessName": user['businessName'],
//     "projectId": user['projectId'],
//     "applicationId": user['applicationId'],
//     "projectUrlId": user['projectUrlId'],
//     "settings": user['settings'],
//     "street": user['street'],
//     "country": user['country'],
//     "region": user['region']
//   });
//   return shops;
// }

Future shopName2Shop(name) async {
  var shops = await getUserShops();
  return shops.firstWhere((e) => e['businessName'] == name,
      orElse: () => {'businessName': '', 'projectId': '', 'applicationId': ''});
}
