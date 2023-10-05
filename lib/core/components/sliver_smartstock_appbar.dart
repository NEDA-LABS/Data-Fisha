import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/app_bar_actions.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/models/SearchFilter.dart';
import 'package:smartstock/core/services/util.dart';

class SliverSmartStockAppBar extends SliverAppBar {
  SliverSmartStockAppBar({
    super.key,
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
    List<SearchFilter> filters = const [],
  }) : super(
          expandedHeight: showSearch ? (filters.isNotEmpty ? 156 : 126) : 65,
          centerTitle: true,
          title: Text(title, overflow: TextOverflow.ellipsis),
          bottom: showSearch
              ? (searchInput as PreferredSizeWidget?) ??
                  _getToolBarSearchInput(
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
                  onPressed: () => onBack != null
                      ? onBack()
                      : Navigator.of(context).maybePop(),
                )
              : null,
          // actions: getAppBarActions(context,),
          pinned: true,
          snap: true,
          floating: true,
        );
}

PreferredSizeWidget _getToolBarSearchInput(
  Function(String)? onSearch,
  String placeholder,
  TextEditingController? searchTextController,
  BuildContext context,
  List<SearchFilter> filters,
) {
  return PreferredSize(
    preferredSize: Size.fromHeight(filters.isNotEmpty ? 116 : 66),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).colorScheme.surfaceVariant
          ),
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
                  if (onSearch != null && code != null) {
                    onSearch('-1:$code');
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
