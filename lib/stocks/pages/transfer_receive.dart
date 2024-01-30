import 'package:flutter/widgets.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/PageBase.dart';
import 'package:smartstock/core/pages/SaleLikePage.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/add_purchase_to_cart.dart';

var _onGetPrice = compose([doubleOrZero, propertyOr('purchase', (p0) => 0)]);

class TransferReceivePage extends PageBase {
  final OnBackPage onBackPage;

  const TransferReceivePage({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'TransferReceivePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TransferReceivePage> {
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      // showDiscountView: false,
      title: 'Receive transfer',
      // backLink: '/stock/transfers',
      // customerLikeLabel: 'Transferred from?',
      // onSubmitCart: prepareOnSubmitTransfer(context, 'receive'),
      onGetPrice: _onGetPrice,
      onBack: widget.onBackPage,
      onAddToCart: _onPrepareSalesAddToCartView(context, false),
      // onCustomerLikeList: getOtherShopsNames,
      // onCustomerLikeAddWidget: transferAddShopContent,
      // checkoutCompleteMessage: 'Transfer complete.',
      onGetProductsLike: getStockFromCacheOrRemote,
      onCheckout: (List<CartModel> carts) {},
    );
  }

  _onPrepareSalesAddToCartView(context, _) =>
      (product, onAddToCart) => addPurchaseToCartView(
          onGetPrice: _onGetPrice,
          cart: CartModel(product: product, quantity: 1),
          onAddToCart: onAddToCart,
          context: context);
}
