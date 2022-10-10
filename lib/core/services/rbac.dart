bool hasRbaAccess(user, List<String> groups, String? pagePath) {
  user ??= {};
  bool groupAccess;
  bool pathAccess;
  if (groups.length == 1 && groups[0] == '*') {
    groupAccess = true;
  } else {
    var result = groups
        .where((x) =>
            '$x'.toLowerCase().trim() == '${user['role']}'.toLowerCase().trim())
        .toList();
    // print(result);
    // print(result is List && result.length == 1);
    groupAccess = (result is List && result.length == 1);
  }
  if (pagePath != null &&
      pagePath.trim().isNotEmpty &&
      user != null &&
      user['acl'] != null &&
      user['acl'] is List) {
    var result = user['acl']
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
