import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';

class AuthGuard extends BFastUIRouterGuard {
  @override
  Future<bool> canActivate(String url) async {
    BFast.auth().authenticated().then((value) {
      BFast.auth().setCurrentUser(value);
    }).catchError((onError) {
      BFast.auth().setCurrentUser(null);
    });
    var user = await BFast.auth().currentUser();
    // print(user != null ? user['username'] : null);
    if (user != null) {
      return true;
    } else {
      BFastUI.navigateTo('/login');
      return false;
    }
  }
}
