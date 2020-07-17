import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';

class AuthGuard extends BFastUIRouterGuard {
  @override
  Future<bool> canActivate(String url) async {
    // await Future.delayed(Duration(seconds: 5));
    BFast.auth().authenticated().then((value) {
      print(value);
      BFast.auth().setCurrentUser(value?.data);
    }).catchError((onError){
print(onError);
    });
    var user = await BFast.auth().currentUser();
    print(user);
    print("******");
    if (user != null) {
      return true;
    } else {
      BFastUI.navigation(moduleName: 'account').to('/account/login');
      print("********&######");
      return false;
    }
  }
}
