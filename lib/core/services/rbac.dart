import 'package:smartstock/core/services/util.dart';

bool hasRbaAccess(user, List<String> groups, String? pagePath) {
  user ??= {};
  bool groupAccess;
  bool pathAccess;
  var getRole = propertyOr('role', (p0) => '');
  var getACL = propertyOr('acl', (p0) => []);
  if (groups.length == 1 && groups[0] == '*') {
    groupAccess = true;
  } else {
    var result = groups
        .where((x) =>
            '$x'.toLowerCase().trim() ==
            '${getRole(user)}'.toLowerCase().trim())
        .toList();
    // print(result);
    // print(result is List && result.length == 1);
    groupAccess = (result is List && result.length == 1);
  }
  if (pagePath != null &&
      pagePath.trim().isNotEmpty &&
      user != null &&
      getACL(user) != null &&
      getACL(user) is List) {
    var result = itOrEmptyArray(getACL(user))
        .where((x) => x
            .toString()
            .toLowerCase()
            .trim()
            .startsWith(pagePath.toLowerCase().trim()))
        .toString();
    pathAccess = (result != null && result is List && result.isNotEmpty);
  } else {
    pathAccess = false;
  }
  // print('--------');
  // print(groupAccess);
  // print(pathAccess);
  // print('--------');
  return (groupAccess || pathAccess);
}
