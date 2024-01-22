import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/services/cache_factory.dart';

const _customersTable = 'customers';
// const _customersId = 'customers';

Future getLocalCustomers(App app) async {
  return await CacheFactory().getAll(app, _customersTable);
}

Future saveLocalCustomers(App app, List customers) async {
  var setAll = CacheFactory().prepareSetAll(app, _customersTable);
  await setAll(customers.map((e) => e['id']).toList(), customers);
  return [];
}

Future saveLocalCustomer(App app, customer) => CacheFactory()
    .prepareSetData(app, _customersTable)(customer['id'], customer);
