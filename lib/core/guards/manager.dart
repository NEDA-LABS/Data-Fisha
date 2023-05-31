// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:smartstock/core/services/cache_user.dart';
//
// import '../services/rbac.dart';
//
// class ManagerGuard extends RouteGuard {
//   @override
//   String get redirectTo => '/sales/';
//
//   @override
//   Future<bool> canActivate(String path, ParallelRoute route) async {
//     var user = await getLocalCurrentUser();
//     return hasRbaAccess(user,['manager', 'admin'], null);
//   }
// }
