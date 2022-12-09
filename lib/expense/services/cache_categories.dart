import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _itemsTable = 'expense';
const _itemsId = 'categories';

/// get expense categories from local storage. [App app] => List
Future getLocalExpenseCategories(App app) {
  var getFromCache = CacheFactory().prepareGetData(app, _itemsTable);
  var getItems = composeAsync([itOrEmptyArray, getFromCache]);
  return getItems(_itemsId);
}

/// save expense categories to local storage. [App app, List items] => *
Future saveLocalExpenseCategories(App app, items) {
  var setItems = CacheFactory().prepareSetData(app, _itemsTable);
  return setItems(_itemsId, itOrEmptyArray(items));
}

/// add category to exist local list. [App app, List items] => List
Future addLocalExpenseCategory(App app, item) async {
  List expenses = await getLocalExpenseCategories(app);
  expenses.add(item);
  return saveLocalExpenseCategories(app, expenses);
}
