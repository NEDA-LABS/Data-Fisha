import 'package:smartstock_pos/core/services/cache_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _userTable = 'user';
const _userId = 'current';

getLocalCurrentUser() async {
  var getUser = CacheFactory().prepareGetData(smartstockApp, _userTable);
  return getUser(_userId);
}

setLocalCurrentUser(user)async{
  var setData = CacheFactory().prepareSetData(smartstockApp, _userTable);
  return setData(_userId, user);
}

removeLocalCurrentUser()async{
  var rm = CacheFactory().prepareRemoveData(smartstockApp, _userTable);
  return rm(_userId);
}
