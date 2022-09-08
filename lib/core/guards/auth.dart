import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/services/cache_user.dart';


class AuthGuard extends RouteGuard {
  @override
  String get redirectTo => '/login';

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    var user = await getLocalCurrentUser();
    return user is Map && user['username'] != null;
  }
}
