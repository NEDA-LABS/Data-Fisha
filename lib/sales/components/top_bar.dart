import 'package:flutter/material.dart';
import 'package:smartstock_pos/account/services/user.dart';
import 'package:smartstock_pos/sales/components/search_input.dart';

import '../../core/services/util.dart';

AppBar salesTopBar({title = "Sales", showSearch = false}) {
  return AppBar(
    title: Text(title),
    bottom: showSearch ? searchInput() : null,
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (title == 'Sales') {
          navigateTo('/shop');
        } else {
          navigateTo("/sales");
        }
      },
    ),
    actions: <Widget>[
      Builder(
        builder: (context) => PopupMenuButton(
          onSelected: (value) {},
          itemBuilder: (context) => [
            PopupMenuItem(
              child: TextButton(
                onPressed: () => localLogOut(),
                child: Row(
                  children: const [
                    Text("Logout"),
                    Icon(
                      Icons.exit_to_app,
                      // color: Theme.of(context).primaryColorDark,
                    )
                  ],
                ),
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    ],
  );
}
