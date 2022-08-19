import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/search_input.dart';

import '../../account/services/user.dart';
import '../services/util.dart';

AppBar topBAr({
  title = "",
  showSearch = false,
  searchInput,
  onSearch,
  Function openDrawer,
  showBack = true,
  backLink = "/",
}) {
  return AppBar(
    title: Text(title),
    // toolbarHeight: 56,
    elevation: 0,
    bottom: showSearch ? searchInput ?? toolBarSearchInput(onSearch) : null,
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
