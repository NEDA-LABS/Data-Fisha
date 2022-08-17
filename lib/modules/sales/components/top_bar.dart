import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/app/states/login.state.dart';
import 'package:smartstock_pos/modules/sales/components/search_input.dart';
import 'package:smartstock_pos/util.dart';

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
                onPressed: () => getState<LoginPageState>().logOut(),
                child: Row(
                  children: [
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
          icon: Icon(Icons.more_vert),
        ),
      ),
    ],
  );
}
