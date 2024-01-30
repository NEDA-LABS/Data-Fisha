import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/helpers/util.dart';

class SearchByFilter {
  final Widget child;
  final Map<String, String> value;

  SearchByFilter({required this.child, required this.value});
}

class SearchByContainer extends StatelessWidget {
  final Function(Map<String, String> searchMap) onUpdate;
  final String currentValue;
  final String title;
  final List<SearchByFilter> filters;

  const SearchByContainer({
    super.key,
    required this.onUpdate,
    required this.currentValue,
    required this.filters,
    this.title = "Choose a filter",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getIsSmallScreen(context) ? 120 : 130,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 32,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(100)),
      child: InkWell(
        onTap: () => _showSearchByOptions(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const WhiteSpacer(width: 8),
            Expanded(
                child: LabelLarge(
              text: currentValue,
              overflow: TextOverflow.ellipsis,
              color: Theme.of(context).colorScheme.onPrimary,
            )),
            SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  _showSearchByOptions(BuildContext context) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const WhiteSpacer(width: 8),
                  const Icon(Icons.filter_list),
                  const WhiteSpacer(width: 8),
                  TitleMedium(text: title),
                ],
              ),
              const WhiteSpacer(height: 16),
              ...filters.map((e) {
                return ListTile(
                  onTap: () {
                    onUpdate(e.value);
                    Navigator.of(context).maybePop();
                  },
                  title: e.child,
                  subtitle: const HorizontalLine(),
                );
              }),
              // ListTile(
              //   onTap: () {
              //     onUpdate({'name': "Customer", 'value': 'customer'});
              //     Navigator.of(context).maybePop();
              //   },
              //   title: const BodyLarge(text: "Customer name"),
              // ),
              // const HorizontalLine(),
              // ListTile(
              //   onTap: () {
              //     onUpdate({'name': "Invoice date", 'value': 'date'});
              //     Navigator.of(context).maybePop();
              //   },
              //   title: const BodyLarge(text: "Invoice date"),
              // ),
            ],
          ),
        ),
        context);
  }
}
