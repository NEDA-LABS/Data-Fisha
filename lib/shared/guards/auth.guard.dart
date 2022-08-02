import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router_guard.dart';
import 'package:bfastui/controllers/navigation.dart';

class AuthGuard extends RouterGuardAdapter {
  @override
  Future<bool> canActivate(String url) async {
    var user = await BFast.auth().currentUser();
    if (user != null) {
      return true;
    } else {
      navigateTo('/login');
      return false;
    }
  }
}
