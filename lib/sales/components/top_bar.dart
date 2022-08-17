import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smartstock_pos/account/services/user.dart';

import '../../core/services/util.dart';
import '../states/sales.dart';

PreferredSizeWidget get _searchInput {
  return PreferredSize(
      child: consumerComponent<SalesState>(
        builder: (context, state) => Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white70,
          ),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
            decoration: const InputDecoration(
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
      preferredSize: const Size.fromHeight(52));
}

AppBar salesTopBar({title = "Sales", showSearch = false}) {
  return AppBar(
    title: Text(title),
    bottom: showSearch ? _searchInput : null,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (title == 'Sales') {
          navigateTo('/');
        } else {
          navigateTo("/sales/");
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
                  children: [
                    const Text("Logout"),
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).primaryColorDark,
                    )
                  ],
                ),
              ),
            ),
          ],
          icon: const Icon(Icons.account_circle),
        ),
      ),
    ],
  );
}
