import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:smartstock/core/services/api_subscription.dart';
import 'package:smartstock/core/services/cache_subscription.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:uuid/uuid.dart';

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

Future syncSubscriptionFromRemoteServer() async {
  var user = await getLocalCurrentUser();
  user = user is Map ? user : {};
  if (user['id'] == null) {
    throw Exception('No user can\'t check for subscription');
  }
  var subscription = await getSubscriptionLocal(user['projectId']??const Uuid().v4());
  subscription ??= await getSubscriptionStatus(user['id']);
  getSubscriptionStatus(user['id']).then((value) async {
    if (value is Map) {
      await saveSubscriptionLocal(value,user['projectId']??const Uuid().v4());
    }
  }).catchError((err) {
    if (kDebugMode) {
      print(err);
    }
  });
  return subscription;
}
