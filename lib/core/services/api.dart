import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

var getHttpRequest = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  (path) => get(Uri.parse(path)),
]);
