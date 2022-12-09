import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _itemsTable = 'items';
const _itemsId = 'items';

Future getLocalItems(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().prepareGetData(app, _itemsTable),
    ])(_itemsId);

Future saveLocalItems(App app, items) => CacheFactory()
    .prepareSetData(app, _itemsTable)(_itemsId, itOrEmptyArray(items));
