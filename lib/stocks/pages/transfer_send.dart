import 'package:flutter/widgets.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/add_transfer_to_cart.dart';

var _onGetPrice = compose([doubleOrZero, propertyOr('purchase', (p0) => 0)]);

class TransferSendPage extends PageBase {
  final OnBackPage onBackPage;

  const TransferSendPage({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'TransferSendPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TransferSendPage> {
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      onQuickItem: (onAddToCartSubmitCallback) {},
      // showDiscountView: false,
      title: 'Send transfer',
      // backLink: '/stock/transfers',
      // customerLikeLabel: 'Transfer to?',
      // onSubmitCart: prepareOnSubmitTransfer(context, 'send'),
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
      (product, onAddToCart) => addTransferToCartView(
            onGetPrice: _onGetPrice,
            cart: CartModel(product: product, quantity: 1),
            onAddToCart: onAddToCart,
            context: context,
          );
}
