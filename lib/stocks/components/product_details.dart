import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/offset_quantity_content.dart';
import 'package:smartstock/stocks/components/product_movement.dart';
import 'package:smartstock/stocks/pages/product_edit.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductDetail extends StatelessWidget {
  final Map item;
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ProductDetail({
    super.key,
    required this.item,
    required this.onChangePage,
    required this.onBackPage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: HeadlineSmall(text: item['product'] ?? ''),
              dense: true,
            ),
            Wrap(
              children: [
                MenuContextAction(
                  onPressed: () {
                    var nav = Navigator.of(context);
                    nav.maybePop().then((v) {
                      onChangePage(
                          ProductEditPage(product: item, onBackPage: onBackPage));
                    });
                  },
                  title: 'Edit details',
                ),
                MenuContextAction(
                  onPressed: () {
                    var nav = Navigator.of(context);
                    nav.maybePop().then((value) {
                      showDialogOrModalSheet(
                        ProductMovementDetails(item: item),
                        context,
                      );
                    });
                  },
                  title: 'Track movement',
                ),
                MenuContextAction(
                  onPressed: () {
                    var nav = Navigator.of(context);
                    nav.maybePop().then(
                      (value) {
                        showDialogDelete(
                          onDone: (p0) {
                            nav.maybePop();
                          },
                            context: context,
                            name: item['product'],
                            onDelete: () => deleteProduct(item['id']));
                      },
                    );
                  },
                  title: 'Delete',
                  textColor: Theme.of(context).colorScheme.error,
                )
              ],
            ),
            ...item.keys
                .where((k) => k != 'product')
                .map((e) => listItem(e, item))
          ],
        ),
      ),
    );
  }

  listItem(e, item) {
    return ListTile(
      title: BodyLarge(text: '$e'),
      subtitle: BodyMedium(text: '${item[e]}'),
      dense: true,
    );
  }
}
