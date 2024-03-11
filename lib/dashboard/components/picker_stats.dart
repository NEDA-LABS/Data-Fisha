import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/DisplayTextSmall.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/helpers/util.dart';

class PickerStats extends StatefulWidget {
  final Map picker;

  const PickerStats({super.key, required this.picker});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PickerStats> {
  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    return Container(
      // width: 490,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _getProfilePicture(),
                const WhiteSpacer(width: 8),
                _getPickerDetails(context, isSmallScreen),
                const WhiteSpacer(width: 8),
                Expanded(child: Container()),
                isSmallScreen ? Container() : _getCollected(context)
              ],
            ),
          ),
          _getBottom(context, isSmallScreen)
        ],
      ),
    );
  }

  Widget _getCollected(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 50),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.recycling_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const WhiteSpacer(width: 4),
          TitleLarge(
            text: formatNumber('18768', decimals: 0),
            color: Theme.of(context).colorScheme.onSurface,
          )
        ],
      ),
    );
  }

  Widget _getPickerDetails(BuildContext context, bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          text: widget.picker['name'],
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        // const WhiteSpacer(height: 4),
        TitleMedium(
            text: 'ID: ${widget.picker['id']}',
            color: Theme.of(context).colorScheme.onPrimary),
        const WhiteSpacer(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const WhiteSpacer(width: 4),
            LabelMedium(
                text: '${widget.picker['address']}'.trim().isEmpty
                    ? 'N/A'
                    : '${widget.picker['address']}',
                color: Theme.of(context).colorScheme.onPrimary),
          ],
        ),
        const WhiteSpacer(height: 4),
        isSmallScreen ? _getCollected(context) : Container(),
        const WhiteSpacer(height: 4),
        OutlinedButton(
            onPressed: () {},
            child: LabelLarge(
                text: 'CONTACT',
                color: Theme.of(context).colorScheme.onPrimary))
      ],
    );
  }

  Widget _getProfilePicture() {
    return CircleAvatar(
      backgroundImage: NetworkImage(widget.picker['image']),
      radius: 48,
    );
  }

  Widget _getBottom(BuildContext context, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.all(16),
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _getBottomKgAndAmount(context),
                  const WhiteSpacer(height: 24),
                  _getBottomAccountedAndScore(context)
                ],
              )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _getBottomKgAndAmount(context)),
                  Expanded(child: _getBottomAccountedAndScore(context))
                ],
              ),
      ),
    );
  }

  Widget _getBottomKgAndAmount(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DisplayTextSmall(text: '530Kg'),
        const WhiteSpacer(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: TitleMedium(
            text: 'Amount raised',
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const WhiteSpacer(height: 4),
        const TitleLarge(text: 'TZS 530,000'),
      ],
    );
  }

  Widget _getBottomAccountedAndScore(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BodyLarge(text: 'Wastes accounted for'),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Chip(
                label: const LabelLarge(text: 'Polycarbonate (PC)'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                side: BorderSide.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Chip(
                label: const LabelLarge(text: 'Poly (PE)'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                side: BorderSide.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Chip(
                label: const LabelLarge(text: 'Poly Tere (PETE or PET)'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                side: BorderSide.none,
              ),
            )
          ],
        ),
        const WhiteSpacer(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: TitleMedium(
            text: 'Total credit sold',
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        const WhiteSpacer(height: 4),
        const TitleLarge(text: '0.530'),
      ],
    );
  }
}
