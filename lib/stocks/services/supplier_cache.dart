import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock_pos/core/services/util.dart';

import '../../core/services/cache_factory.dart';

const _suppliersTable = 'suppliers';
const _suppliersId = 'suppliers';

Future getLocalSuppliers(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().get(app, _suppliersTable),
    ])(_suppliersId);

Future saveLocalSuppliers(App app, suppliers) => CacheFactory()
    .set(app, _suppliersTable)(_suppliersId, itOrEmptyArray(suppliers));
