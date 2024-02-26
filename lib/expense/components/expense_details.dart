import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/expense/services/expenses.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpenseDetail extends StatelessWidget {
  final Map item;
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;
  final void Function() onRefresh;

  const ExpenseDetail({
    super.key,
    required this.item,
    required this.onChangePage,
    required this.onBackPage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: HeadlineSmall(text: item['name'] ?? ''),
              dense: true,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item['receiptLink'] != null
                      ? MenuContextAction(
                          onPressed: () {
                            final Uri url = Uri.parse('${item['receiptLink']}');
                            launchUrl(
                              url,
                              mode: isNativeMobilePlatform()
                                  ? LaunchMode.inAppWebView
                                  : LaunchMode.externalApplication,
                              webOnlyWindowName: '_blank'
                            ).then((_) {}).catchError((error) {
                              showTransactionCompleteDialog(context, error);
                            });
                          },
                          title: 'View receipt',
                        )
                      : Container(),
                  MenuContextAction(
                    onPressed: () {
                      var nav = Navigator.of(context);
                      nav.maybePop().then(
                        (value) {
                          return showDialog(
                            context: context,
                            builder: (_) {
                              return DeleteDialog(
                                onDone: (p0){
                                  Navigator.of(context).maybePop();
                                },
                                message:
                                    'Delete of "${item['name']}" is permanent, do you wish to continue ? ',
                                onConfirm: () => deleteExpense(item['id']),
                              );
                            },
                          );
                        },
                      ).whenComplete(() => onRefresh());
                    },
                    title: 'Delete',
                    textColor: Colors.red,
                  )
                ],
              ),
            ),
            ...item.keys
                .where((k) => (k != 'name' &&
                    k != 'updatedAt' &&
                    k != 'updatedAt' &&
                    k != 'receiptLink' &&
                    k != 'timer'))
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
