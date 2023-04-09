import 'package:flutter/material.dart';
import 'package:smartstock/core/components/app_bar_actions.dart';
import 'package:smartstock/core/services/util.dart';

SliverAppBar getSliverSmartStockAppBar({
  required String title,
  bool showSearch = false,
  bool showBack = false,
  Function()? onBack,
  Widget? searchInput,
  String backLink = '/',
  String searchHint = 'Type to search...',
  Function? openDrawer,
  Function(String)? onSearch,
  TextEditingController? searchTextController,
  required BuildContext context,
}) {
  return SliverAppBar(
    expandedHeight: showSearch ? 100 : 65,
    centerTitle: true,
    // foregroundColor: const Color(0xFF1C1C1C),
    // backgroundColor: Colors.white,
    title: Text(title, overflow: TextOverflow.ellipsis),
    bottom: showSearch
        ? (searchInput as PreferredSizeWidget?) ??
            _toolBarSearchInput(onSearch, searchHint, searchTextController)
        : null,
    leading: showBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => onBack != null ? onBack() : navigateTo(backLink))
        : null,
    actions: getAppBarActions(context),
    pinned: true,
    snap: true,
    floating: true,
  );
}

PreferredSizeWidget _toolBarSearchInput(
  Function(String)? onSearch,
  String placeholder,
  TextEditingController? searchTextController,
) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: searchTextController,
          autofocus: false,
          autocorrect: false,
          maxLines: 1,
          minLines: 1,
          onChanged: (text) {
            if (onSearch != null) {
              onSearch(text);
            }
          },
          decoration: InputDecoration(
              hintText: placeholder,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search_sharp)),
        ),
      ),
    ),
  );
}
