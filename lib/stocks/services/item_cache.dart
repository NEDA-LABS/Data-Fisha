import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock_pos/core/services/util.dart';

import '../../core/services/cache_factory.dart';

const _itemsTable = 'items';
const _itemsId = 'items';

Future getLocalItems(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().get(app, _itemsTable),
    ])(_itemsId);

Future saveLocalItems(App app, items) => CacheFactory()
    .set(app, _itemsTable)(_itemsId, itOrEmptyArray(items));
