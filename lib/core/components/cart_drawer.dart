import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/util.dart';

class CartDrawer extends StatefulWidget {
  final Function(dynamic) onCheckout;
  final Function(dynamic) onGetPrice;
  final Function(String) onRemoveItem;
  final Future Function({bool skipLocal}) onCustomerLikeList;
  final Widget Function() onCustomerLikeAddWidget;
  final Function(String, dynamic) onAddItem;
  final bool wholesale;
  final String customerLikeLabel;
  final dynamic customer;
  final dynamic onCustomer;
  final List carts;
  final bool showCustomerLike;
  final bool showDiscountView;

  const CartDrawer({
    required this.carts,
    required this.onCheckout,
    required this.onGetPrice,
    required this.onRemoveItem,
    required this.onCustomerLikeList,
    required this.onCustomerLikeAddWidget,
    required this.onAddItem,
    required this.wholesale,
    this.customerLikeLabel = 'Choose customer',
    required this.customer,
    required this.onCustomer,
    required this.showCustomerLike,
    this.showDiscountView = true,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CartDrawer> {
  dynamic _customer;
  Map states = {'discount': 0, 'loading': false};
  TextEditingController controller = TextEditingController();

  _prepareUpdateState() => ifDoElse(
      (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getIsSmallScreen(context)
          ? AppBar(
              title: const TitleLarge(text: 'Cart'),
              // elevation: 0,
              // backgroundColor: Theme.of(context).colorScheme.surface,
              centerTitle: true,
            )
          : null,
      body: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
                left: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: .2))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.showCustomerLike
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoicesInput(
                        choice: _customer,
                        placeholder: widget.customerLikeLabel,
                        showBorder: true,
                        onChoice: widget.onCustomer,
                        onLoad: widget.onCustomerLikeList,
                        getAddWidget: widget.onCustomerLikeAddWidget,
                        onField: (x) =>
                            x?['name'] ?? x?['displayName'] ?? '$x'),
                  )
                : Container(),
            Expanded(
              child: ListView.builder(
                controller: ScrollController(),
                itemCount: widget.carts.length,
                itemBuilder: _cartListItemBuilder(
                  widget.carts,
                  widget.wholesale,
                  widget.onAddItem,
                  widget.onRemoveItem,
                  widget.onGetPrice,
                ),
              ),
            ),
            _cartSummary(
              widget.carts,
              widget.wholesale,
              context,
              widget.onCheckout,
              widget.onGetPrice,
            )
          ],
        ),
      ),
    );
  }

  Widget _cartSummary(List carts, wholesale, context, onCheckout, onGetPrice) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          carts.isNotEmpty && onGetPrice(carts[0].product) != null
              ? _totalAmountRow(carts, wholesale, onGetPrice)
              : Container(),
          carts.isNotEmpty &&
                  onGetPrice(carts[0].product) != null &&
                  widget.showDiscountView == true
              ? _discountRow(
                  states['discount'],
                  (v) {
                    _prepareUpdateState()({'discount': doubleOrZero(v)});
                  },
                )
              : Container(),
          Container(
            margin: const EdgeInsets.all(8),
            height: 54,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: states['loading']
                ? _progressIndicator()
                : _submitButton(carts, states['discount'], wholesale,
                    onCheckout, _prepareUpdateState(), onGetPrice),
          )
        ],
      ),
    );
  }

  _submitButton(List carts, discount, bool wholesale, onCheckout, updateState,
          onGetPrice) =>
      TextButton(
        onPressed: () {
          updateState({'loading': true});
          onCheckout(discount)
              .whenComplete(() => updateState({'loading': false}));
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.onPrimary),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          children: [
            const Expanded(child: BodyLarge(text: 'Checkout')),
            FittedBox(
              child: BodyLarge(
                text:
                    '${_formatPrice(_getFinalTotal(carts, discount, wholesale, onGetPrice))}',
              ),
            )
          ],
        ),
      );

  _formatPrice(price) =>
      NumberFormat.currency(name: 'TZS ').format(doubleOrZero('$price'));

  _getFinalTotal(List carts, dynamic discount, bool wholesale, onGetPrice) =>
      carts.fold(-discount,
          (dynamic t, c) => t + getProductPrice(c, wholesale, onGetPrice));

  _progressIndicator() => const Center(
      child: CircularProgressIndicator(backgroundColor: Colors.white));

  _totalAmountRow(List carts, wholesale, onGetPrice) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Expanded(child: TitleMedium(text: "Total")),
            TitleMedium(
                text: '${cartTotalAmount(carts, wholesale, onGetPrice)}')
          ],
        ),
      );

  _discountRow(dynamic discount, Function(dynamic) onDiscount) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Expanded(child: BodyLarge(text: 'Discount ( TZS )')),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), border: Border.all()),
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              width: 150,
              child: TextField(
                autofocus: false,
                maxLines: 1,
                minLines: 1,
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: onDiscount,
                decoration: const InputDecoration(
                  hintText: "Discount",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _checkoutCartItem(
      {required cart,
      required bool wholesale,
      required BuildContext context,
      required Function(String, dynamic) onAddItem,
      required Function(dynamic) onGetPrice,
      required Function(String) onRemoveItem}) {
    var quantity = cart.quantity;
    var price = onGetPrice(cart.product) ??
        propertyOr('amount', (p0) => 0)(cart.product);
    var wQuantity = propertyOr('wholesaleQuantity', (p0) => 1);
    var subTotal = quantity * price;
    return Column(
      children: [
        ListTile(
          title: BodyLarge(
              text: '${cart.product['product'] ?? cart.product['name']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wholesale
                  ? BodyLarge(
                      text:
                          '$quantity (x${wQuantity(cart.product)}) @ $price = TZS $subTotal')
                  : BodyMedium(text: '$quantity @ $price = TZS $subTotal'),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.remove_circle,
                          color: Theme.of(context).primaryColor),
                      onPressed: () => onAddItem(cart.product['id'], -1)),
                  IconButton(
                      icon: Icon(Icons.add_circle,
                          color: Theme.of(context).primaryColor),
                      onPressed: () => onAddItem(cart.product['id'], 1)),
                ],
              )
            ],
          ),
          isThreeLine: false,
          trailing: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () => onRemoveItem(cart.product['id']),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: HorizontalLine())
      ],
    );
  }

  _cartListItemBuilder(carts, wholesale, onAddItem, onRemoveItem, onGetPrice) =>
      (context, index) => _checkoutCartItem(
          cart: carts[index],
          onGetPrice: onGetPrice,
          wholesale: wholesale,
          context: context,
          onAddItem: onAddItem,
          onRemoveItem: onRemoveItem);
}
