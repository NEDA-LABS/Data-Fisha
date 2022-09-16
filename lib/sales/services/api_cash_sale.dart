import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

var prepareGetRemoteCashSales =
    (startAt, size, String product, String username) => composeAsync([
          (invoices) => itOrEmptyArray(invoices),
          (app) => executeHttp(() => getHttpRequest(
              '${shopFunctionsURL(app)}/sale/cash?size=$size&startAt=$startAt&product=$product&username=$username')),
          map(shopToApp),
        ]);
