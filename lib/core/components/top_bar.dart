import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/util.dart';

class StockAppBar extends PreferredSize with Disposable {
  final String title;
  final bool showSearch;
  final bool showBack;
  final Widget? searchInput;
  final String backLink;
  final String searchHint;
  final Function? openDrawer;
  final Function(String)? onSearch;
  final dynamic debounceTime;
  Timer? _debounce;

  StockAppBar({
    Key? key,
    this.title = "",
    this.showSearch = false,
    this.searchInput,
    this.onSearch,
    this.openDrawer,
    this.showBack = true,
    this.backLink = "/",
    this.searchHint = "",
    this.debounceTime = 500,
  }) : super(
            key: key,
            preferredSize: Size.fromHeight(showSearch ? 104 : 56),
            child: Container());

  @override
  AppBar build(BuildContext context) => AppBar(
          elevation: 0,
          title: Text(title, overflow: TextOverflow.ellipsis),
          bottom: showSearch
              ? searchInput as PreferredSizeWidget? ??
                  _toolBarSearchInput(onSearch, searchHint, debounceTime)
              : null,
          leading: showBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => navigateTo(backLink))
              : null,
          actions: <Widget>[
            Builder(
                builder: (context) => PopupMenuButton(
                    onSelected: (dynamic value) {},
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
                    icon: const Icon(Icons.more_vert)))
          ]);

  PreferredSizeWidget _toolBarSearchInput(
    Function(String)? onSearch,
    String placeholder,
    dynamic debounceTime,
  ) =>
      PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              alignment: Alignment.centerLeft,
              child: TextField(
                  autofocus: false,
                  autocorrect: false,
                  maxLines: 1,
                  minLines: 1,
                  onChanged: (text) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(Duration(milliseconds: debounceTime),
                        () => onSearch!(text));
                  },
                  decoration: InputDecoration(
                      hintText: placeholder, border: InputBorder.none))));

  @override
  void dispose() {
    _debounce?.cancel();
  }
}
