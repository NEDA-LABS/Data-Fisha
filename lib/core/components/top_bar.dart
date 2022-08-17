import 'package:flutter/material.dart';

import '../../account/services/user.dart';
import '../services/util.dart';

AppBar topBAr({
  title = "",
  showSearch = false,
  searchInput,
  Function openDrawer,
  showBack = true,
  backLink = "/",
}) {
  return AppBar(
    title: Text(title),
    bottom: showSearch ? searchInput : null,
    leading: showBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => navigateTo(backLink),
          )
        : null,
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
                    // Icon(
                    //   Icons.exit_to_app,
                    //   // color: Theme.of(context).primaryColorDark,
                    // ),
                    Text("Logout"),
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
