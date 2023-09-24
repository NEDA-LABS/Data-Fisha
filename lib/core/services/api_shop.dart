import 'package:bfast/controller/function.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';

Future updateShopLocation({required String latitude,required String longitude})async{
  var shop = await getActiveShop();
  var user = await getLocalCurrentUser();
  var patchShopLocation = preparePatchRequest({'longitude': longitude, 'latitude': latitude});
  var url = '$baseUrl/account/${user?['id']??'-1'}/shops/${shop?['projectId']??'-1'}/location';
  request() => executeHttp(() => patchShopLocation(url));
  return request();
}