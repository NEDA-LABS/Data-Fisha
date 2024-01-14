import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/helpers/util.dart';

const _categoriesTable = 'categories';
const _categoriesId = 'categories';

Future getLocalCategories(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().prepareGetData(app, _categoriesTable),
    ])(_categoriesId);

Future saveLocalCategories(App app, categories) => CacheFactory()
    .prepareSetData(app, _categoriesTable)(_categoriesId, itOrEmptyArray(categories));
