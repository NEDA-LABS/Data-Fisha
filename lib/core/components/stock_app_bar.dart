import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/app_bar_actions.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/models/SearchFilter.dart';
import 'package:smartstock/core/services/util.dart';

SliverAppBar getSliverSmartStockAppBar(
    {required String title,
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
    List<SearchFilter> filters = const []}) {
  return SliverAppBar(
    expandedHeight: showSearch ? (filters.isNotEmpty ? 130 : 100) : 65,
    centerTitle: true,
    title: Text(title, overflow: TextOverflow.ellipsis),
    bottom: showSearch
        ? (searchInput as PreferredSizeWidget?) ??
            _toolBarSearchInput(
              onSearch,
              searchHint,
              searchTextController,
              context,
              filters,
            )
        : null,
    leading: showBack
        ? IconButton(
            icon: const Icon(Icons.chevron_left),
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
  BuildContext context,
  List<SearchFilter> filters,
) {
  return PreferredSize(
    preferredSize: Size.fromHeight(filters.isNotEmpty ? 100 : 50),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
              prefixIcon: const Icon(Icons.search),
              suffixIcon: mobileQrScanIconButton(
                context,
                (code) {
                  if (onSearch != null) {
                    onSearch('$code');
                  }
                },
              ),
            ),
          ),
        ),
        filters.isNotEmpty
            ? SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  children: filters.map((e) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: LabelMedium(text: e.name),
                        selected: e.selected,
                        selectedColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onSelected: (value) => e.onClick(),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Container(),
      ],
    ),
  );
}
