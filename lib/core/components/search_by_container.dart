import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/services/util.dart';

class SearchByContainer extends StatelessWidget {
  final Function(Map<String, String> searchMap) onUpdate;
  final String currentValue;

  const SearchByContainer(
      {super.key, required this.onUpdate, required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getIsSmallScreen(context) ? 135 : 150,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 32,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
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
            )),
            const SizedBox(
                width: 32, height: 32, child: Icon(Icons.arrow_drop_down))
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
              const Row(
                children: [
                  WhiteSpacer(width: 8),
                  Icon(Icons.filter_list),
                  WhiteSpacer(width: 8),
                  TitleMedium(text: "Choose a filter"),
                ],
              ),
              const WhiteSpacer(height: 16),
              ListTile(
                onTap: () {
                  onUpdate({'name': "Customer", 'value': 'customer'});
                  Navigator.of(context).maybePop();
                },
                title: const BodyLarge(text: "Customer name"),
              ),
              const HorizontalLine(),
              ListTile(
                onTap: () {
                  onUpdate({'name': "Invoice date", 'value': 'date'});
                  Navigator.of(context).maybePop();
                },
                title: const BodyLarge(text: "Invoice date"),
              ),
              // const HorizontalLine(),
              // ListTile(
              //   onTap: () {
              //     _updateState(() {
              //       _searchByMap = {'name': "Invoice due date", 'value': 'due'};
              //     });
              //     Navigator.of(context).maybePop();
              //   },
              //   title: const BodyLarge(text: "Invoice due date"),
              // ),
              // const HorizontalLine()
            ],
          ),
        ),
        context);
  }
}
