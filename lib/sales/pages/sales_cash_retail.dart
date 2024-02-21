import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/sales/components/add_sale_to_cart.dart';
import 'package:smartstock/sales/components/sale_checkout_dialog.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/products.dart';

class SalesCashRetail extends PageBase {
  final OnBackPage onBackPage;

  const SalesCashRetail({super.key, required this.onBackPage})
      : super(pageName: 'SalesCashRetail');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesCashRetail> {
  final TextEditingController _searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      onQuickItem: (submitCallback) {
        _onAddToCart({}, submitCallback);
      },
      searchTextController: _searchTextController,
      title: 'Create sale',
      // onSubmitCart: onSubmitRetailSale,
      onBack: widget.onBackPage,
      // customerLikeLabel: 'Select customer',
      onGetPrice: _getPrice,
      onAddToCart: _onAddToCart,
      // onCustomerLikeList: getCustomerFromCacheOrRemote,
      // onCustomerLikeAddWidget: () => const CreateCustomerContent(),
      // checkoutCompleteMessage: 'Checkout completed.',
      onGetProductsLike: getProductsFromCacheOrRemote,
      onCheckout: _onCheckout,
    );
  }

  _onAddToCart(Map product, OnAddToCartSubmitCallback submitCallback) {
    showDialogOrFullScreenModal(
      AddSale2CartDialogContent(
        onGetPrice: _getPrice,
        cart: CartModel(product: product, quantity: 1),
        onAddToCartSubmitCallback: (cart) {
          submitCallback(cart);
          Navigator.of(context).maybePop();
        },
      ),
      context,
    );
  }

  // _onPrepareSalesAddToCartView(context) {
  //   return (product, onAddToCart) {
  //     return salesAddToCart(
  //       onGetPrice: _getPrice,
  //       cart: CartModel(product: product, quantity: 1),
  //       onAddToCart: onAddToCart,
  //       context: context,
  //     );
  //   };
  // }

  dynamic _getPrice(product) => doubleOrZero(product['retailPrice']);

  _onCheckout(List<CartModel> carts) {
    showDialogOrFullScreenModal(SaleCheckoutDialog(carts), context);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
