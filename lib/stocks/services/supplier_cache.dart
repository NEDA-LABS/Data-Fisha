import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _suppliersTable = 'suppliers';
const _suppliersId = 'suppliers';

Future getLocalSuppliers(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().prepareGetData(app, _suppliersTable),
    ])(_suppliersId);

Future saveLocalSuppliers(App app, suppliers) => CacheFactory()
    .prepareSetData(app, _suppliersTable)(_suppliersId, itOrEmptyArray(suppliers));
