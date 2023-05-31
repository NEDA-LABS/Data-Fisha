import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/offset_quantity_content.dart';
import 'package:smartstock/stocks/components/product_movement.dart';
import 'package:smartstock/stocks/pages/product_edit.dart';
import 'package:smartstock/stocks/services/product.dart';

class ProductDetail extends StatelessWidget {
  final Map item;
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ProductDetail({
    Key? key,
    required this.item,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: HeadlineSmall(text: item['product'] ?? ''),
              dense: true,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  outlineActionButton(
                    onPressed: () {
                      var nav = Navigator.of(context);
                      nav.maybePop().then((v) {
                        onChangePage(ProductEditPage(item, onBackPage: onBackPage));
                      });
                    },
                    title: 'Edit details',
                  ),
                  outlineActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: OffsetQuantityContent(
                              productId: item['id'],
                              product: item['product'],
                            ),
                          ),
                        ),
                      );
                    },
                    title: 'Offset quantity',
                  ),
                  outlineActionButton(
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
                  outlineActionButton(
                    onPressed: () {
                      var nav = Navigator.of(context);
                      nav.maybePop().then(
                        (value) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return DeleteDialog(
                                message:
                                    'Delete of "${item['product']}" is permanent, do you wish to continue ? ',
                                onConfirm: () => deleteProduct(item['id']),
                              );
                            },
                          );
                        },
                      );
                    },
                    title: 'Delete',
                    textColor: Colors.red,
                  )
                ],
              ),
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
