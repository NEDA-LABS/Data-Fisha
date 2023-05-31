// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:smartstock/core/services/cache_shop.dart';
// import 'package:smartstock/core/services/cache_user.dart';
//
// class ActiveShopGuard extends RouteGuard {
//   @override
//   String get redirectTo => '/account/shop';
//
//   @override
//   Future<bool> canActivate(String path, ParallelRoute route) async {
//     var user = await getLocalCurrentUser();
//     var shop = await getActiveShop();
//     return shop != null && user != null;
//   }
// }
