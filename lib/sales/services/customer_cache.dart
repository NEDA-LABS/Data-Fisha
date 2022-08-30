import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock_pos/core/services/util.dart';

import '../../core/services/cache_factory.dart';

const _customersTable = 'customers';
const _customersId = 'customers';

Future getLocalCustomers(App app) => composeAsync([
  itOrEmptyArray,
  CacheFactory().get(app, _customersTable),
])(_customersId);

Future saveLocalCustomers(App app, customers) => CacheFactory()
    .set(app, _customersTable)(_customersId, itOrEmptyArray(customers));
