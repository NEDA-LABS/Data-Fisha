// import 'dart:async';
//
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:smartstock/core/services/cache_shop.dart';
// import 'package:smartstock/core/services/cache_user.dart';
// import 'package:smartstock/core/services/util.dart';
//
// class AlreadyAuthGuard extends RouteGuard {
//   @override
//   FutureOr<bool> canActivate(String path, ParallelRoute<dynamic> route) async {
//     var user = await getLocalCurrentUser();
//     var isLogin = ifDoElse((y) => y == null, (_) => true, (_) {
//       removeActiveShop();
//       navigateTo('/account/shop');
//       return false;
//     });
//     return isLogin(user);
//   }
// }
