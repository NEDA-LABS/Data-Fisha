import 'dart:convert';

import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';

StoreRef _getStore(name) =>
    StoreRef(ifDoElse((f) => f is String, (x) => x, (_) => 'cache')(name));

_getDbIfNotExist(initializer) =>
    ifDoElse((x) => x != null, (x) async => x, initializer);

class CacheFactory {
  static final CacheFactory _singleton = CacheFactory._internal();

  factory CacheFactory() => _singleton;

  CacheFactory._internal();

  Database? _db;

  _lazyInitialize(_) async {
    // Get the sembast database factory according to the current platform
    // * sembast_web for FlutterWeb and Web
    // * sembast_sqflite and sqflite on Flutter iOS/Android/MacOS
    // * sembast_sqflite and sqflite3 ffi on Flutter Windows/Linux and dart VM (might require extra initialization steps)
    // var factory = ;
    // var store = StoreRef(app?.projectId ?? 'cache');
    // Open the database
    _db = await getDatabaseFactory().openDatabase('smartstock.db');
    // await store.record('key').put(db, 'value');
    // Not needed in a flutter application
    // await db.close();
    return _db;
  }

  Future Function(String? a, dynamic b) prepareSetData(
          App app, String collection) =>
      (String? key, dynamic data) async {
        var getSingleDb = _getDbIfNotExist(_lazyInitialize);
        var db = await getSingleDb(_db);
        var store = _getStore(cacheDatabaseName(app)(collection));
        return await store.record(key).put(db, data, merge: true);
      };

  Function(String key) prepareGetData(App app, String collection) =>
      (String key) async {
        var getSingleDb = _getDbIfNotExist(_lazyInitialize);
        var db = await getSingleDb(_db);
        var store = _getStore(cacheDatabaseName(app)(collection));
        var data = await store.record(key).get(db);
        return data is Map || data is List
            ? jsonDecode(jsonEncode(data))
            : data;
      };

  Future Function(String key) prepareRemoveData(App app, String collection) =>
      (String key) async {
        var getSingleDb = _getDbIfNotExist(_lazyInitialize);
        var db = await getSingleDb(_db);
        var store = _getStore(cacheDatabaseName(app)(collection));
        return await store.record(key).delete(db);
      };

  clearAll(App app, String collection) async {
    var getSingleDb = _getDbIfNotExist(_lazyInitialize);
    var getDbName = cacheDatabaseName(app);
    var db = await getSingleDb(_db);
    return await _getStore(getDbName(collection)).drop(db);
  }

  getAll(App app, String collection) async {
    var getSingleDb = _getDbIfNotExist(_lazyInitialize);
    var getDbName = cacheDatabaseName(app);
    var db = await getSingleDb(_db);
    var store = _getStore(getDbName(collection));
    return await store.find(db);
  }

  prepareSetAll(App app, String collection) =>
      (List keys, List values) async {
        var getDb = _getDbIfNotExist(_lazyInitialize);
        var getDbName = cacheDatabaseName(app);
        var db = await getDb(_db);
        var store = _getStore(getDbName(collection));
        return await store.records(keys).put(db, values, merge: true);
      };

  keys(App app, String collection) async {
    var getSingleDb = _getDbIfNotExist(_lazyInitialize);
    var getDbName = cacheDatabaseName(app);
    var db = await getSingleDb(_db);
    var store = _getStore(getDbName(collection));
    return await store.findKeys(db);
  }
}
