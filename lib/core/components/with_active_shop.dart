import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/services/cache_shop.dart';

class WithActiveShop extends StatelessWidget {
  final Widget Function(Map shop) onChild;

  const WithActiveShop({super.key, required this.onChild});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getActiveShop(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return onChild(snapshot.data is Map ? snapshot.data : {});
      },
    );
  }
}
