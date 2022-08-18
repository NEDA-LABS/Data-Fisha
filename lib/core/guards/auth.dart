import 'package:flutter_modular/flutter_modular.dart';

import '../services/cache_user.dart';

class AuthGuard extends RouteGuard {
  @override
  String get redirectTo => '/login';

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    var user = await getLocalCurrentUser();
    return user is Map && user['username'] != null;
    // if (user is Map && user['username'] != null) {
    //   return true;
    // } else {
    // var checkUser = ifDoElse(
    //   (u) => ,
    //   (_) => true,
    //   (_) async {
    //     return false;
    //   },
    // );
    // return checkUser(user);
  }
}
// }
