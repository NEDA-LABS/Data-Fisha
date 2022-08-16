import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock_pos/configurations.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';

class CacheFactory {
  static final CacheFactory _singleton = CacheFactory._internal();

  factory CacheFactory() => _singleton;

  CacheFactory._internal();

  Database _db;

  _lazyInitialize() async {
    // Get the sembast database factory according to the current platform
    // * sembast_web for FlutterWeb and Web
    // * sembast_sqflite and sqflite on Flutter iOS/Android/MacOS
    // * sembast_sqflite and sqflite3 ffi on Flutter Windows/Linux and dart VM (might require extra initialization steps)
    var factory = getDatabaseFactory();
    // var store = StoreRef(app?.projectId ?? 'cache');
    // Open the database
    _db = await factory
        .openDatabase('${cacheDatabaseName(smartstockApp)('cache.db')}');
    // await store.record('key').put(db, 'value');

    // Not needed in a flutter application
    // await db.close();
  }

  StoreRef _getStore(name) =>
      StoreRef(ifDoElse((f) => f is String, (x) => x, (_) => 'cache')(name));

  Database _getDbIfNotExist() =>
      ifDoElse((f) => _db != null, (_) => _db, (_) => _lazyInitialize())('');

  Future Function(String a, dynamic b) set(App app, String collection) => (String key, dynamic data) async {
        var db = _getDbIfNotExist();
        var store = _getStore(cacheDatabaseName(app)(collection));
        return await store.record(key).put(db, data, merge: true);
      };

  Function(String key) get(App app, String collection) => (String key) async {
        var db = _getDbIfNotExist();
        var store = _getStore(cacheDatabaseName(app)(collection));
        return await store.record(key).get(db);
      };

  Future Function(String key) remove(App app, String collection) => (String key) async {
        var db = _getDbIfNotExist();
        var store = _getStore(cacheDatabaseName(app)(collection));
        return await store.record(key).delete(db);
      };

  clearAll(App app, String collection) async {
    var db = _getDbIfNotExist();
    var store = _getStore(cacheDatabaseName(app)(collection));
    return await store.drop(db);
  }

  keys(App app, String collection) async {
    var db = _getDbIfNotExist();
    var store = _getStore(cacheDatabaseName(app)(collection));
    return await store.findKeys(db);
  }
}
