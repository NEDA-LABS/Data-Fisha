import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/services/cache_factory.dart';

const _customersTable = 'customers';

Future getLocalCustomers(App app) async {
  var r = await CacheFactory().getAll(app, _customersTable);
  // print(r);
  // print(r.runtimeType);
  return itOrEmptyArray(r);
}

Future saveLocalCustomers(App app, List customers) async {
  var setAll = CacheFactory().prepareSetAll(app, _customersTable);
  await setAll(customers.map((e) => e['id']).toList(), customers);
  return [];
}

Future saveLocalCustomer(App app, customer) async {
  var setData = CacheFactory().prepareSetData(app, _customersTable);
  var r = await setData(customer['id'], customer);
  return r;
}
