import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/helpers/configs.dart';

const _userTable = 'user';
const _userId = 'current';

Future getLocalCurrentUser() async {
  var getUser = CacheFactory().prepareGetData(smartStockApp, _userTable);
  return getUser(_userId);
}

setLocalCurrentUser(user)async{
  Future<dynamic> Function(String, dynamic) setData = CacheFactory().prepareSetData(smartStockApp, _userTable);
  return setData(_userId, user);
}

removeLocalCurrentUser()async{
  var rm = CacheFactory().prepareRemoveData(smartStockApp, _userTable);
  return rm(_userId);
}
