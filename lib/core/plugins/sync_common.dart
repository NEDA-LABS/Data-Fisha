import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/util.dart';

Future syncLocalDataToRemoteServer() async {
  List keys = await getLocalSyncsKeys();
  if (kDebugMode) {
    print('Data to sync: ${keys.length}');
  }
  for (var key in keys) {
    var element = await getLocalSync(key);
    var getUrl = propertyOr('url', (p0) => '');
    var getPayload = propertyOr('payload', (p0) => {});
    var response = await post(Uri.parse(getUrl(element)),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(getPayload(element)));
    if (response.statusCode == 200) {
      await removeLocalSync(key);
      return key;
    } else {
      throw response.body;
    }
  }
}
