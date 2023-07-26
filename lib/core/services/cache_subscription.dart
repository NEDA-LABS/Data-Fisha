import 'package:bfast/options.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _tableName = 'cache_subscription';
var _app = App(applicationId: 'smartstock', projectId: 'smartstock');

Future saveSubscriptionLocal(dynamic data) {
  Future<dynamic> Function(String, dynamic) setData =
      CacheFactory().prepareSetData(_app, _tableName);
  return setData('subscription', data);
}

Future getSubscriptionLocal() async {
  var getData = CacheFactory().prepareGetData(_app, _tableName);
  return getData('subscription');
}

Future removeSubscriptionLocal() {
  var removeData = CacheFactory().prepareRemoveData(_app, _tableName);
  return removeData('subscription');
}
