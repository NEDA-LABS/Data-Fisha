import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/models/SearchFilter.dart';

class EComContextMenu extends StatelessWidget {
  final List<SearchFilter> filters;
  const EComContextMenu({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: filters.map((e) {
            return Container(
              margin: const EdgeInsets.all(8),
              child: FilterChip(
                label: LabelLarge(text: e.name),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.surface,
                selected: e.selected,
                labelStyle: e.selected
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)
                    : TextStyle(
                    color: Theme.of(context).colorScheme.primary),
                checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                selectedColor: Theme.of(context).colorScheme.primary,
                onSelected: (value) => e.onClick(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
