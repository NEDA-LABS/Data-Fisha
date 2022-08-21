import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock_pos/core/services/util.dart';

import '../../core/services/cache_factory.dart';

const _categoriesTable = 'categories';
const _categoriesId = 'categories';

Future getLocalCategories(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().get(app, _categoriesTable),
    ])(_categoriesId);

Future saveLocalCategories(App app, categories) => CacheFactory()
    .set(app, _categoriesTable)(_categoriesId, itOrEmptyArray(categories));
