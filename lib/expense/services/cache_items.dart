import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _itemsTable = 'expense';
const _itemsId = 'items';

/// get expense items from local storage. [App app] => List
Future getLocalExpenseItems(App app) {
  var getFromCache = CacheFactory().prepareGetData(app, _itemsTable);
  var getItems = composeAsync([itOrEmptyArray, getFromCache]);
  return getItems(_itemsId);
}

/// save expense items to local storage. [App app, List items] => *
Future saveLocalExpenseItems(App app, items){
  var setItems = CacheFactory().prepareSetData(app, _itemsTable);
  return setItems(_itemsId, itOrEmptyArray(items));
}
