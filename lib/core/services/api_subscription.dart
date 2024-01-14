import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future getSubscriptionCostPerMonth(String uid) async {
  var httpGetRequest = prepareHttpGetRequest();
  return httpGetRequest('$baseUrl/account/$uid/billing/cost');
}

Future getSubscriptionStatus(String uid) async {
  var httpGetRequest = prepareHttpGetRequest();
  return httpGetRequest('$baseUrl/account/$uid/billing/subscription');
}
