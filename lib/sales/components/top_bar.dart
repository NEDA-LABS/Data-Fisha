import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../app/states/login.dart';
import '../../common/services/util.dart';
import '../states/sales.state.dart';

PreferredSizeWidget get _searchInput {
  return PreferredSize(
      child: consumerComponent<SalesState>(
        builder: (context, state) => Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white70,
          ),
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.center,
          child: FormBuilderTextField(
            autofocus: false,
            maxLines: 1,
            // controller: state.searchInputController,
            minLines: 1,
            initialValue: state.searchKeyword,
            onChanged: (value) {
              state.filterProducts(value ?? '');
            },
            name: 'query',
            decoration: InputDecoration(
              hintText: "Enter a keyword...",
              border: InputBorder.none,
//                suffixIcon: state.searchKeyword.isNotEmpty
//                    ? InkWell(
//                        child: Icon(Icons.clear),
//                        onTap: () {
//                          state.resetSearchKeyword('');
//                        },
//                      )
//                    : null,
            ),
          ),
        ),
      ),
      preferredSize: Size.fromHeight(52));
}

AppBar salesTopBar({title = "Sales", showSearch = false}) {
  return AppBar(
    title: Text(title),
    bottom: showSearch ? _searchInput : null,
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
              child: FlatButton(
                onPressed: () {
                  getState<LoginPageState>().logOut();
                },
                child: Row(
                  children: [
                    Text("Logout"),
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).primaryColorDark,
                    )
                  ],
                ),
              ),
            ),
          ],
          icon: Icon(Icons.account_circle),
        ),
      ),
    ],
  );
}