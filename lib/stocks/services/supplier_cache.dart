import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/services/cache_factory.dart';

const _suppliersTable = 'suppliers';
const _suppliersId = 'suppliers';

Future getLocalSuppliers(App app) async {
  var getSuppliersLocally = CacheFactory().prepareGetData(app, _suppliersTable);
  var suppliers = await getSuppliersLocally(_suppliersId);
  return itOrEmptyArray(suppliers);
}

Future saveLocalSuppliers(App app, suppliers) async {
  var saveSupplierLocal = CacheFactory().prepareSetData(app, _suppliersTable);
  return saveSupplierLocal(_suppliersId, itOrEmptyArray(suppliers));
}
