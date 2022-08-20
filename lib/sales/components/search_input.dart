import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../states/sales.dart';

PreferredSizeWidget searchInput() {
  SalesState state = getState<SalesState>();
  return PreferredSize(
    child: selectorComponent<SalesState, String>(
      selector: (s) => s.searchKeyword,
      builder: (context, value) => Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white70,
        ),
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.center,
        child: TextField(
          autofocus: false,
          maxLines: 1,
          // controller: state.searchInputController,
          minLines: 1,
          onChanged: (value) => state.filterProducts(value ?? ''),
          decoration: const InputDecoration(
            hintText: "Enter a keyword...",
            border: InputBorder.none,
          ),
        ),
      ),
    ),
    preferredSize: const Size.fromHeight(52),
  );
}
