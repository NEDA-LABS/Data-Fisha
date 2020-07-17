import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';

class AlreadyAuthGuard extends BFastUIRouterGuard {
  @override
  Future<bool> canActivate(String url) async {
    BFast.auth().authenticated().then((value) {
      BFast.auth().setCurrentUser(value?.data);
    }).catchError((onError) {
      BFast.auth().setCurrentUser(null);
    });
    var user = await BFast.auth().currentUser();
    if (user == null) {
      return true;
    } else {
      BFastUI.navigation(moduleName: 'account').to('/sales');
      return false;
    }
  }
}
