import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';

class AuthGuard extends BFastUIRouterGuard {
  @override
  Future<bool> canActivate(String url) async {
    // BFast.auth().authenticated().then((value) {
    //   BFast.auth().setCurrentUser(value);
    // }).catchError((onError) {
    //   try {
    //     if (onError['message'].toString().contains('209')) {
    //       BFast.auth().setCurrentUser(null);
    //     }
    //   } catch (e) {}
    // });
    var user = await BFast.auth().currentUser();
    if (user != null) {
      return true;
    } else {
      BFastUI.navigateTo('/login');
      return false;
    }
  }
}
