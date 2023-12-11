import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';

class WithRoleBasedAccessControl extends StatelessWidget {
  final Widget Function(Map shop) onChild;
  final List<String> roles;

  const WithRoleBasedAccessControl(
      {super.key, required this.onChild, required this.roles});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLocalCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        var data = snapshot.data is Map ? snapshot.data : {};
        var hasAccess = roles
            .map((e) => e.toLowerCase())
            .toList()
            .contains('${data['role']}'.toLowerCase());
        if (hasAccess) {
          return onChild(data);
        }
        return Container();
      },
    );
  }
}
