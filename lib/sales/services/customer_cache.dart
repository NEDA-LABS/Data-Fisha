import 'package:bfast/options.dart';

import '../../core/services/cache_factory.dart';

const _customersTable = 'customers';
const _customersId = 'customers';

Future getLocalCustomers(App app) =>
    CacheFactory().getAll(app, _customersTable);

Future saveLocalCustomers(App app, customers) async {
  for (var customer in (customers as List)) {
    saveLocalCustomer(app, customer);
  }
  return 'done';
}

Future saveLocalCustomer(App app, customer) =>
    CacheFactory().set(app, _customersTable)(customer['displayName'], customer);
