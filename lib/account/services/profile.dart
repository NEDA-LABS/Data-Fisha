import 'package:smartstock/account/services/api_account.dart';
import 'package:smartstock/core/services/cache_user.dart';

Future updateProfileDetails(details) async {
  Map user = await getLocalCurrentUser();
  await updateUserDetailsRemote(user, details);
  user.addAll(details);
  await setLocalCurrentUser(user);
  return {"message": "done update"};
}
