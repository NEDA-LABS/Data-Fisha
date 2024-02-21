import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/add_sale_to_cart.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/products.dart';

class InvoiceSalePage extends PageBase {
  final OnBackPage onBackPage;

  const InvoiceSalePage({super.key, required this.onBackPage})
      : super(pageName: 'InvoiceSalePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<InvoiceSalePage> {
  final TextEditingController _searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      wholesale: false,
      onQuickItem: (onAddToCartSubmitCallback) {},
      title: 'Invoice sale',
      searchTextController: _searchTextController,
      // backLink: '/sales/invoice',
      // onSubmitCart: onSubmitInvoice,
      // customerLikeLabel: 'Select customer',
      onBack: widget.onBackPage,
      onGetPrice: _getPrice,
      onAddToCart: _onPrepareSalesAddToCartView(context),
      // onCustomerLikeList: getCustomerFromCacheOrRemote,
      // onCustomerLikeAddWidget: () => const CreateCustomerContent(),
      // checkoutCompleteMessage: 'Checkout completed.',
      onGetProductsLike: getProductsFromCacheOrRemote,
      onCheckout: (List<CartModel> carts) {},
    );
  }

  _onPrepareSalesAddToCartView(context) => (product, onAddToCart) {
        salesAddToCart(
          onGetPrice: _getPrice,
          cart: CartModel(product: product, quantity: 1),
          onAddToCart: onAddToCart,
          context: context,
        );
      };

  dynamic _getPrice(product) => doubleOrZero(product['retailPrice']);

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
