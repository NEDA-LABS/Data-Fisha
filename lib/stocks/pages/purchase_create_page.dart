import 'package:flutter/widgets.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/products.dart';
import 'package:smartstock/stocks/components/add_purchase_to_cart.dart';
import 'package:smartstock/stocks/components/purchase_checkout.dart';

class PurchaseCreatePage extends PageBase {
  final OnBackPage onBackPage;

  const PurchaseCreatePage({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'PurchaseCreatePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PurchaseCreatePage> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      onQuickItem: (onAddToCartSubmitCallback) {
        return _onAddToCart({}, onAddToCartSubmitCallback);
      },
      wholesale: false,
      title: 'Offset data',
      onBack: widget.onBackPage,
      searchTextController: _editingController,
      onGetRetailPrice: _onGetPrice,
      onAddToCart: _onAddToCart,
      onGetProductsLike: (skipLocal, stringLike) async {
        return [];
      },
      //getCategoryFromCacheOrRemote,
      onCheckout: _onCheckout,
    );
  }

  _onAddToCart(Map product, OnAddToCartSubmitCallback submitCallback) {
    // showDialogOrFullScreenModal(
    return AddPurchase2CartDialogContent(
      onGetPrice: _onGetPrice,
      cart: CartModel(product: product, quantity: 1),
      onAddToCartSubmitCallback: (cart) {
        submitCallback(cart);
        Navigator.of(context).maybePop();
        _editingController.clear();
      },
    );
    // ,
    // context,
    // );
  }

  _onGetPrice(product) {
    return doubleOrZero('${product['purchase']}');
  }

  void _onCheckout(List<CartModel> carts, clearCart) {
    showDialogOrFullScreenModal(
      PurchaseCheckout(
        carts: carts,
        onDone: (data) {
          clearCart();
          getProductsFromCacheOrRemote(true).catchError((e) => []);
          Navigator.of(context).maybePop().whenComplete(() {
            widget.onBackPage();
          });
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
