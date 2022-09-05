import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/util.dart';

import '../../core/services/cache_factory.dart';

const _categoriesTable = 'categories';
const _categoriesId = 'categories';

Future getLocalCategories(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().prepareGetData(app, _categoriesTable),
    ])(_categoriesId);

Future saveLocalCategories(App app, categories) => CacheFactory()
    .prepareSetData(app, _categoriesTable)(_categoriesId, itOrEmptyArray(categories));
