import 'package:smartstock_pos/core/services/cache_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _userTable = 'user';
const _userId = 'current';

getLocalCurrentUser() async {
  var getUser = CacheFactory().get(smartstockApp, _userTable);
  return getUser(_userId);
}

setLocalCurrentUser(user)async{
  var setData = CacheFactory().set(smartstockApp, _userTable);
  return setData(_userId, user);
}

removeLocalCurrentUser()async{
  var rm = CacheFactory().remove(smartstockApp, _userTable);
  return rm(_userId);
}
