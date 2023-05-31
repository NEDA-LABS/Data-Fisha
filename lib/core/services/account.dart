import 'package:bfast/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
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

logOut(BuildContext context, OnGetModulesMenu onGetModulesMenu) {
  removeLocalCurrentUser().then((value) {
    return removeActiveShop();
  }).then((value) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => SmartStockApp(onGetModulesMenu: onGetModulesMenu),
      ),
      (route) => false,
    );
  });
}

Future<List> getUserShops() async {
  var user = await getLocalCurrentUser();
  var getShops = compose([
    itOrEmptyArray,
    propertyOrNull('shops'),
  ]);
  return getShops(user);
}

Future shopName2Shop(name) async {
  var shops = await getUserShops();
  return shops.firstWhere((e) => e['businessName'] == name,
      orElse: () => {'businessName': '', 'projectId': '', 'applicationId': ''});
}
