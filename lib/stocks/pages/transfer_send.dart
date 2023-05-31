import 'package:bfast/util.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/add_transfer_to_cart.dart';
import 'package:smartstock/stocks/components/transfer_add_shop_content.dart';
import 'package:smartstock/stocks/services/transfer.dart';

var _onGetPrice = compose([doubleOrZero, propertyOr('purchase', (p0) => 0)]);

class TransferSendPage extends StatelessWidget {
  final OnBackPage onBackPage;

  const TransferSendPage({
    Key? key,
    required this.onBackPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
        wholesale: false,
        showDiscountView: false,
        title: 'Send transfer',
        backLink: '/stock/transfers',
        customerLikeLabel: 'Transfer to?',
        onSubmitCart: prepareOnSubmitTransfer(context, 'send'),
        onGetPrice: _onGetPrice,
        onBack: onBackPage,
        onAddToCartView: _onPrepareSalesAddToCartView(context, false),
        onCustomerLikeList: getOtherShopsNames,
        onCustomerLikeAddWidget: transferAddShopContent,
        checkoutCompleteMessage: 'Transfer complete.',
        onGetProductsLike: getStockFromCacheOrRemote);
  }

  _onPrepareSalesAddToCartView(context, _) =>
      (product, onAddToCart) => addTransferToCartView(
            onGetPrice: _onGetPrice,
            cart: CartModel(product: product, quantity: 1),
            onAddToCart: onAddToCart,
            context: context,
          );
}
