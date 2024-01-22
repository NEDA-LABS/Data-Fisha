import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/mobileQrScanIconButton.dart';
import 'package:smartstock/core/models/SearchFilter.dart';

class SliverSmartStockAppBar extends SliverAppBar {
  final Widget? searchByView;

  SliverSmartStockAppBar({
    super.key,
    required String title,
    this.searchByView,
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
          title: Text(
            title,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              // color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
          // backgroundColor: Theme.of(context).colorScheme.primary,
          scrolledUnderElevation: 5,
          // surfaceTintColor: Theme.of(context).colorScheme.primary,
          // shadowColor: Theme.of(context).colorScheme.shadow,
          bottom: showSearch
              ? (searchInput as PreferredSizeWidget?) ??
                  _getToolBarSearchInput(onSearch, searchHint,
                      searchTextController, context, filters, searchByView)
              : null,
          leading: showBack
              ? IconButton(
                  // color: Theme.of(context).colorScheme.onPrimary,
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
  Widget? searchByView,
) {
  return PreferredSize(
    preferredSize: Size.fromHeight(filters.isNotEmpty ? 116 : 66),
    child: Container(
      // color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 1),
                color: Theme.of(context).colorScheme.surface),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: searchByView ??
                      Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const WhiteSpacer(width: 4),
                Expanded(
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
              ],
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
                          side: BorderSide.none,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          selected: e.selected,
                          labelStyle: e.selected
                              ? TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary)
                              : null,
                          checkmarkColor:
                              Theme.of(context).colorScheme.onSecondary,
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          onSelected: (value) => e.onClick(),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
        ],
      ),
    ),
  );
}
