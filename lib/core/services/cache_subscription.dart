import 'package:bfast/options.dart';
import 'package:smartstock/core/services/cache_factory.dart';

const _tableName = 'cache_subscription';
var _app = App(applicationId: 'smartstock', projectId: 'smartstock');

Future saveSubscriptionLocal(dynamic data,dynamic userId) async{
  Future<dynamic> Function(String, dynamic) setData =
      CacheFactory().prepareSetData(_app, _tableName);
  return await setData('subscription_$userId', data);
}

Future getSubscriptionLocal(dynamic userId) async {
  var getData = CacheFactory().prepareGetData(_app, _tableName);
  return getData('subscription_$userId');
}

Future removeSubscriptionLocal(dynamic userId) {
  var removeData = CacheFactory().prepareRemoveData(_app, _tableName);
  return removeData('subscription_$userId');
}
