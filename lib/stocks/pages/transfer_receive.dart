import 'package:flutter/widgets.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/products.dart';
import 'package:smartstock/stocks/components/add_transfer_item_to_cart.dart';
import 'package:smartstock/stocks/components/transfer_checkout.dart';

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
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      title: 'Receive transfer',
      onGetPrice: _onGetPrice,
      onBack: widget.onBackPage,
      onAddToCart: _onAddToCart,
      onGetProductsLike: getStockFromCacheOrRemote,
      onCheckout: _onCheckout,
      searchTextController: _editingController,
    );
  }

  void _onCheckout(List<CartModel> carts) {
    showDialogOrFullScreenModal(
      TransferCheckout(
        batchId: generateUUID(),
        type: 'receive',
        carts: carts,
        onDone: (data) {
          getProductsFromCacheOrRemote(true).catchError((e) => []);
          Navigator.of(context).maybePop().whenComplete(() {
            widget.onBackPage();
          });
        },
      ),
      context,
    );
  }

  _onAddToCart(Map product, OnAddToCartSubmitCallback submitCallback) {
    showDialogOrFullScreenModal(
      AddTransferItem2Cart(
        onGetPrice: _onGetPrice,
        cart: CartModel(product: product, quantity: 1),
        onAddToCartSubmitCallback: (cart) {
          submitCallback(cart);
          Navigator.of(context).maybePop();
          _editingController.clear();
        },
      ),
      context,
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
}
