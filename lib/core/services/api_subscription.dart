import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smartstock/core/services/util.dart';

_costHttp(String uid) async {
  var a = await http.get(
    Uri.parse('$baseUrl/account/$uid/billing/cost'),
    headers: getInitialHeaders(),
  );
  return RawResponse(body: a.body, statusCode: a.statusCode);
}

_subscriptionHttp(String uid) async {
  var a = await http.get(
    Uri.parse('$baseUrl/account/$uid/billing/subscription'),
    headers: getInitialHeaders(),
  );
  return RawResponse(body: a.body, statusCode: a.statusCode);
}

Future getSubscriptionCostPerMonth(String uid) async {
  // var getCost = composeAsync([executeRule]);
  return executeRule(() => _costHttp(uid));
}

Future getSubscriptionStatus(String uid) async {
  // var getSub = composeAsync([executeRule]);
  return executeRule(() => _subscriptionHttp(uid));
}
