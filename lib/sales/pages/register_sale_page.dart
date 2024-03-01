import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/sales/components/add_sale_to_cart.dart';
import 'package:smartstock/sales/components/sale_checkout.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/products.dart';

class RegisterSalePage extends PageBase {
  final OnBackPage onBackPage;

  const RegisterSalePage({super.key, required this.onBackPage})
      : super(pageName: 'RegisterSalePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RegisterSalePage> {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      onQuickItem: (submitCallback) => _onAddToCart({}, submitCallback),
      searchTextController: _searchTextController,
      title: 'Create sale',
      onBack: widget.onBackPage,
      onGetRetailPrice: _getRetailPrice,
      onGetWholesalePrice: _getWholesalePrice,
      onAddToCart: _onAddToCart,
      onGetProductsLike: getProductsFromCacheOrRemote,
      onCheckout: _onCheckout,
    );
  }

  _onAddToCart(Map product, OnAddToCartSubmitCallback submitCallback) {
    showDialogOrFullScreenModal(
      AddSale2CartDialogContent(
        onGetRetailPrice: _getRetailPrice,
        onGetWholesalePrice: _getWholesalePrice,
        cart: CartModel(product: product, quantity: 1),
        onAddToCartSubmitCallback: (cart) {
          submitCallback(cart);
          Navigator.of(context).maybePop();
        },
      ),
      context,
    );
  }

  dynamic _getRetailPrice(product) => doubleOrZero(product['retailPrice']);
  dynamic _getWholesalePrice(product) => doubleOrZero(product['wholesalePrice']);

  _onCheckout(List<CartModel> carts, clearCart) {
    showDialogOrFullScreenModal(
      SaleCheckout(
        carts: carts,
        onDone: (data) {
          clearCart();
          Navigator.of(context).maybePop();
        },
      ),
      context,
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
