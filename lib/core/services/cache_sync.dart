import 'package:bfast/options.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _tableName = 'cache_syncs';
var _app = App(applicationId: 'smartstock', projectId: 'smartstock');

Future saveLocalSync(id, url, payload) {
  Future<dynamic> Function(String, dynamic) setData = CacheFactory().prepareSetData(_app, _tableName);
  return setData(id, {"url": url, "payload": payload});
}

Future getAllLocalSync() async {
  var r = await CacheFactory().getAll(_app, _tableName);
  return itOrEmptyArray(r);
}

Future getLocalSyncsKeys() async{
  var keys = await CacheFactory().keys(_app, _tableName);
  return itOrEmptyArray(keys);
}

Future getLocalSync(id) {
  var getData = CacheFactory().prepareGetData(_app, _tableName);
  return getData(id);
}

Future removeLocalSync(id) {
  var removeData = CacheFactory().prepareRemoveData(_app, _tableName);
  return removeData(id);
}
