import 'package:bfast/bfast.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/common/util.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url,_) async {
    var user = await BFast.auth().currentUser();
    if (user != null) {
      return true;
    } else {
      navigateTo('/login');
      return false;
    }
  }
}
