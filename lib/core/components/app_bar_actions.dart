import 'package:flutter/material.dart';
import 'package:smartstock/core/services/account.dart';

List<Widget> getAppBarActions(context) => <Widget>[
      PopupMenuButton(
        // onSelected: (dynamic value) {},
        itemBuilder: (context) => [
          PopupMenuItem(
            child: GestureDetector(
              onTap: () => logOut(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Logout"),
              ),
            ),
          )
        ],
        icon: const Icon(Icons.more_vert),
      )
    ];
