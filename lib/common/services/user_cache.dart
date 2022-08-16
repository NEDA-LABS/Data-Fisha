import 'package:smartstock_pos/common/services/storage_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _userTable = 'user';

currentUser() async {
  var getUser = CacheFactory().get(smartstockApp, _userTable);
  return getUser('current');
}

removeCurrentUser()async{
  var rm = CacheFactory().remove(smartstockApp, _userTable);
  return rm('current');
}