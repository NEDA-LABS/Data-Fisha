import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/HeadineMedium.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/headline_large.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/services/api_subscription.dart';
import 'package:smartstock/core/services/cache_subscription.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:uuid/uuid.dart';

class PaymentBody extends StatefulWidget {
  final dynamic initialSubscription;

  const PaymentBody({
    Key? key,
    required this.initialSubscription,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PaymentBody> {
  var loading = false;
  var _remoteSubscription = {};

  @override
  void initState() {
    _remoteSubscription = widget.initialSubscription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var noGraceInitial = widget.initialSubscription['force'] == true;
        var noGraceRemote = _remoteSubscription['force'] == true;
        if (noGraceRemote == false) {
          return true;
        }
        if (noGraceInitial == false) {
          return true;
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.initialSubscription != null &&
                        widget.initialSubscription['force'] == true
                    ? const BodyLarge(text: 'Subscription Payments')
                    : Container(),
                const TableLikeListRow([
                  TableLikeListTextHeaderCell("Number"),
                  TableLikeListTextHeaderCell("Status")
                ]),
                TableLikeListRow([
                  const TableLikeListTextHeaderCell("0764943055"),
                  TableLikeListTextHeaderCell(
                      "${_getStatus(_remoteSubscription)}")
                ]),
                const TableLikeListRow([
                  TableLikeListTextHeaderCell("Cost ( TZS ) / Month"),
                  TableLikeListTextHeaderCell("Balance ( TZS )")
                ]),
                const HorizontalLine(),
                TableLikeListRow([
                  const TableLikeListTextHeaderCell(""),
                  TableLikeListTextHeaderCell(
                      "${_getBalance(_remoteSubscription)}")
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
Tuma TZ ${formatNumber(_getBalance(_remoteSubscription))} kwenda namba 0764 943 055 ( M-PESA ) jina litatokea Joshua Mshana.

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
      ),
    );
  }

  final _getStatus = propertyOrNull('reason');

  final _getBalance = propertyOrNull('balance');

  _checkSubscription() {
    setState(() {
      loading = true;
    });
    getLocalCurrentUser().then((user) async {
      var subscription = await getSubscriptionStatus(user['id']);
      return {"user": user, "subs": subscription};
    }).then((value) {
      if (value['subs'] is Map && value['subs']['subscription'] == true) {
        _remoteSubscription = value['subs'] ?? {};
        saveSubscriptionLocal(value, value['user']['id'] ?? "nop")
            .catchError((e) {
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
