import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/PrimaryAction.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/sales/models/cart.model.dart';

class CartDrawer extends StatefulWidget {
  final VoidCallback onCartCheckout;
  final OnGetPrice onGetPrice;
  final Function(String) onRemoveItem;

  // final Future Function({bool skipLocal}) onCustomerLikeList;
  // final Widget Function() onCustomerLikeAddWidget;
  final Function(String, dynamic) onAddItem;
  final bool wholesale;

  // final dynamic customer;
  // final dynamic onCustomer;
  final List<CartModel> carts;

  // final bool showCustomerLike;
  // final bool showDiscountView;

  const CartDrawer({
    required this.carts,
    required this.onCartCheckout,
    required this.onGetPrice,
    required this.onRemoveItem,
    // required this.onCustomerLikeList,
    // required this.onCustomerLikeAddWidget,
    required this.onAddItem,
    required this.wholesale,
    // required this.customer,
    // required this.onCustomer,
    // required this.showCustomerLike,
    // this.showDiscountView = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CartDrawer> {
  Map _shop = {};
  // dynamic _customer;
  // Map states = {'discount': 0, 'loading': false};
  // TextEditingController controller = TextEditingController();

  // _updateState(VoidCallback fn) {
  //   if (mounted) {
  //     setState(fn);
  //   }
  // }

  @override
  void initState() {
    getActiveShop().then((value) {
      setState(() {
        _shop = value;
      });
    }).catchError((e) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getIsSmallScreen(context)
          ? AppBar(title: const TitleLarge(text: 'Cart'), centerTitle: true)
          : null,
      body: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: getIsSmallScreen(context)
              ? null
              : Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.shadow,
              width: .2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // widget.showCustomerLike
            //     ? _getChooseCustomerLikeInput()
            //     : Container(),
            Expanded(
              child: widget.carts.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                itemCount: widget.carts.length,
                itemBuilder: _cartListItemBuilder(),
              )
                  : _getEmptyCartView(),
            ),
            widget.carts.isNotEmpty ? _cartSummary() : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _cartSummary() {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          _totalAmountRow(),
          // widget.carts.isNotEmpty &&
          //         widget.onGetPrice(widget.carts[0].product) != null &&
          //         widget.showDiscountView == true
          //     ? _discountRow(shop)
          //     : Container(),
          Container(
            margin: const EdgeInsets.all(8),
            height: 54,
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.primary,
            //   borderRadius: const BorderRadius.all(Radius.circular(4)),
            // ),
            child:
                // widget.carts.isEmpty ? Container() :
                _submitButton(),
          )
        ],
      ),
    );
  }

  _submitButton() {
    return PrimaryAction(
      disabled: widget.carts.isEmpty,
      onPressed: widget.onCartCheckout,
      // () {
      // if (kDebugMode) {
      //   print('++++++++');
      // }
      // updateState({'loading': true});
      // doubleOrZero(states['discount']),

      //     .whenComplete(() => updateState({'loading': false}));
      // },
      // style: ButtonStyle(
      //   foregroundColor:
      //       MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      //   backgroundColor:
      //       MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
      // ),
      text: 'CHECKOUT',
      // child: FittedBox(child: BodyLarge(text: 'CHECKOUT')
      // Row(
      //   children: [
      //     const Expanded(child: BodyLarge(text: 'CHECKOUT')),
      // FittedBox(
      //   child: BodyLarge(
      //     text: '${formatNumber(_getFinalTotal(), decimals: 2)}',
      //   ),
      // )
      // ],
      // ),
    );
  }

  // _getFinalTotal() {
  //   combine(dynamic t, c) =>
  //       t + getProductPrice(c, widget.wholesale, widget.onGetPrice);
  //   return widget.carts.fold(-doubleOrZero(states['discount']), combine);
  // }

  // Widget _progressIndicator() {
  //   return const Center(
  //       child: CircularProgressIndicator(backgroundColor: Colors.white));
  // }

  Widget _totalAmountRow() {
    var getCurrency =
        compose([propertyOrNull('currency'), propertyOrNull('settings')]);
    var amount = formatNumber(
        '${cartTotalAmount(widget.carts, widget.wholesale, widget.onGetPrice)}',
        decimals: 2);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          const Expanded(child: TitleMedium(text: "TOTAL")),
          TitleMedium(text: '${getCurrency(_shop)} $amount')
        ],
      ),
    );
  }

  // _discountRow(Map shop) {
  //   var getCurrency =
  //       compose([propertyOrNull('currency'), propertyOrNull('settings')]);
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       children: [
  //         const Expanded(child: BodyLarge(text: 'Discount')),
  //         const WhiteSpacer(width: 8),
  //         Container(
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(5), border: Border.all()),
  //           padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
  //           width: 150,
  //           child: TextInput(
  //             controller: controller,
  //             type: TextInputType.number,
  //             onText: (v) {
  //               _updateState(() {
  //                 states.addAll({'discount': doubleOrZero(v)});
  //               });
  //             },
  //             placeholder: '${getCurrency(shop)}',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _checkoutCartItem(index) {
    var cart = widget.carts[index];
    var quantity = cart.quantity;
    var price = widget.onGetPrice(cart.product) ??
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
              widget.wholesale
                  ? BodyLarge(
                      text:
                          '$quantity (x${wQuantity(cart.product)}) @ $price = TZS $subTotal')
                  : BodyMedium(text: '$quantity @ $price = TZS $subTotal'),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.remove_circle,
                          color: Theme.of(context).primaryColor),
                      onPressed: () =>
                          widget.onAddItem(cart.product['id'], -1)),
                  IconButton(
                      icon: Icon(Icons.add_circle,
                          color: Theme.of(context).primaryColor),
                      onPressed: () => widget.onAddItem(cart.product['id'], 1)),
                ],
              )
            ],
          ),
          isThreeLine: false,
          trailing: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () => widget.onRemoveItem(cart.product['id']),
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: HorizontalLine())
      ],
    );
  }

  _cartListItemBuilder() {
    return (context, index) {
      return _checkoutCartItem(index);
    };
  }

  Widget _getEmptyCartView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const WhiteSpacer(height: 8),
          const LabelMedium(text: 'Cart is empty. Select items'),
          const WhiteSpacer(height: 8),
        ],
      ),
    );
  }

// Widget _getChooseCustomerLikeInput() {
//   onChoice(p0) {
//     if (mounted) {
//       setState(() {
//         _customer = p0;
//       });
//     }
//     widget.onCustomer(p0);
//   }
//
//   onField(x) {
//     if (x is Map) {
//       return x['name'] ?? x['displayName'] ?? '$x';
//     }
//     return '';
//   }
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//     child: ChoicesInput(
//       choice: _customer,
//       showBorder: true,
//       label: widget.customerLikeLabel,
//       onChoice: onChoice,
//       onLoad: widget.onCustomerLikeList,
//       getAddWidget: widget.onCustomerLikeAddWidget,
//       onField: onField,
//     ),
//   );
// }
}
