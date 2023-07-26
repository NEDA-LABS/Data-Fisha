import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/services/api_subscription.dart';
import 'package:smartstock/core/services/cache_subscription.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';

class PaymentBody extends StatefulWidget {
  final dynamic subscription;

  const PaymentBody({
    Key? key,
    required this.subscription,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PaymentBody> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TableLikeListRow([
                TableLikeListTextHeaderCell("Number"),
                TableLikeListTextHeaderCell("Status")
              ]),
              TableLikeListRow([
                const TableLikeListTextHeaderCell("0764943055"),
                TableLikeListTextHeaderCell(
                    "${_getStatus(widget.subscription)}")
              ]),
              const TableLikeListRow([
                TableLikeListTextHeaderCell("Cost ( TZS ) / Month"),
                TableLikeListTextHeaderCell("Balance ( TZS )")
              ]),
              const HorizontalLine(),
              TableLikeListRow([
                const TableLikeListTextHeaderCell("10,000"),
                TableLikeListTextHeaderCell(
                    "${_getBalance(widget.subscription)}")
              ]),
              // const Text(
              //     'Ukimaliza weka kumbukumbu namba apo chini. Kisha bofya thibitisha malipo.'),
              // TextInput(
              //   onText: (v) {},
              //   placeholder: 'Kumbukumbu namba',
              // ),
              // raisedButton(
              //   title: 'Thibitisha malipo.',
              //   height: 40,
              // ),
              // const Text('Payment instruction'),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HeadlineSmall(text: 'Lipa kwa simu'),
                      const WhiteSpacer(height: 16),
                      const HorizontalLine(),
                      const WhiteSpacer(height: 16),
                      BodyLarge(text: '''
Tuma TZ ${formatNumber(_getBalance(widget.subscription))} kwenda namba 0764 943 055 ( M-PESA ) jina litatokea Joshua Mshana.

Ukishalipa tuma ujuma kwenda namba 0764 943 055 ukisema umeshalipa.
                      ''')
                    ],
                  ),
                ),
              ),
              const WhiteSpacer(height: 16),
              InkWell(
                onTap: loading ? null : _checkSubscription,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: BodyLarge(
                      text: loading ? 'PLEASE WAIT...' : 'ALREADY PAID'),
                ),
              )
              // SizedBox(height: 16),
              // Card(
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Text('MITANDAO MINGINE'),
              //       HorizontalLine(),
              //       Text('''
              //
              //       ''')
              //     ],
              //   ),
              // ),
              // SizedBox(height: 16),
              // Card(
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Text('BENKI'),
              //       HorizontalLine(),
              //       Text('''
              //
              //       ''')
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() {}

  final _getStatus = propertyOrNull('reason');

  final _getBalance = propertyOrNull('balance');

  _checkSubscription() {
    setState(() {
      loading = true;
    });
    getLocalCurrentUser().then((value) {
      return getSubscriptionStatus(value['id']);
    }).then((value) {
      if (value is Map && value['subscription'] == true) {
        saveSubscriptionLocal(value).catchError((e) {
          if (kDebugMode) {
            print(e);
          }
        });
        Navigator.of(context).maybePop();
      } else {
        showInfoDialog(context, 'It seems payment not received yet');
      }
    }).catchError((err) {
      showInfoDialog(context, err, title: 'Error');
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
