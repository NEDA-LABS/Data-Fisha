import 'package:bfast/util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/core/services/cache_user.dart';
import 'package:smartstock_pos/core/services/util.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, _) async {
    var user = await getLocalCurrentUser();
    var checkUser = ifDoElse((u) => u != null, (_) async => true, (_) async {
      navigateTo('/login');
      return false;
    });
    return checkUser(user);
  }
}
