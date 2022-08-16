import 'package:bfast/util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/common/services/user.dart';
import 'package:smartstock_pos/common/services/util.dart';
import 'package:smartstock_pos/configurations.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, _) async {
    var user = await currentUser();
    var checkUser = ifDoElse((u) => u != null, (_) => true, (_) {
      navigateTo('/login');
      return false;
    });
    return checkUser(user);
  }
}
