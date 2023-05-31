import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/HeadineMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/api_customer.dart';
import 'package:smartstock/sales/services/cache_customer.dart';

class CreateCustomerContent extends StatefulWidget {
  const CreateCustomerContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateCustomerContent> {
  Map states = {"loading": false};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            Row(
              children: [
                const Expanded(flex: 1, child: BodyLarge(text: 'New customer')),
                const WhiteSpacer(width: 16),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              ],
            ),
            TextInput(
                onText: (d) => _updateState({'displayName': d}),
                label: "Name",
                error: states['error_d'] ?? '',
                placeholder: 'Required'),
            TextInput(
                onText: (d) => _updateState({'phone': d}),
                label: "Phone",
                error: states['error_p'] ?? '',
                placeholder: 'Required'),
            TextInput(
                onText: (d) => _updateState({'email': d}),
                label: "Email",
                placeholder: "( Optional )"),
            TextInput(
                onText: (d) => _updateState({'tin': d}),
                label: "TIN",
                placeholder: "( Optional )"),
            Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: states['loading']
                            ? null
                            : () => _createCustomer(states, _updateState),
                        child: BodyLarge(
                          text: states['loading']
                              ? "Waiting..."
                              : "Create Customer",
                          // style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(states['error'] ?? '')
          ],
        ),
      ),
    );
  }

  _updateState(dynamic x) {
    if (mounted && x is Map) {
      setState(() {
        states.addAll(x);
      });
    }
  }

  _validateName(data) => data is String && data.isNotEmpty;

  _validatePhone(data) => data is String && data.isNotEmpty;

  _createCustomer(Map<dynamic, dynamic> states, updateState) {
    updateState({'error_d': '', 'error_p': ''});
    if (!_validateName(states['displayName'])) {
      updateState({'error_d': 'Name required'});
      return;
    }
    if (!_validatePhone(states['phone'])) {
      updateState({'error_p': 'Phone number required'});
      return;
    }
    var customer = {
      'displayName': states['displayName'],
      'phone': states['phone'],
    };
    if (states['email'] != null) customer['email'] = states['email'];
    if (states['tin'] != null) customer['tin'] = states['tin'];
    var createCustomer = prepareCreateCustomer(customer);
    getActiveShop().then((shop) {
      updateState({'loading': true});
      createCustomer(shop)
          .then((value) {
            saveLocalCustomer(shopToApp(shop), customer);
            Navigator.of(context).maybePop();
          })
          .catchError((onError) => updateState({'error': onError.toString()}))
          .whenComplete(() => updateState({'loading': false}));
    }).catchError((onError) => updateState({'error': onError.toString()}));
  }
}
