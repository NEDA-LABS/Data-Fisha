import 'package:flutter/widgets.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/add_expense_to_cart.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/services/purchase.dart';

expenseCreatePage(BuildContext context) => SaleLikePage(
      wholesale: false,
      title: 'Create expense',
      backLink: '/expense/expenses',
      customerLikeLabel: '',
      onSubmitCart: prepareOnSubmitPurchase(context),
      showCustomerLike: false,
      onGetPrice: (product) {
        return ''; //doubleOrZero('${product['purchase']}');
      },
      onAddToCartView: _onPrepareExpenseAddToCartView(context, false),
      onCustomerLikeList: ({skipLocal = false}) async => [],
      onCustomerLikeAddWidget: () => Container(),
      checkoutCompleteMessage: 'Expense recorded.',
      onProductLike: ({skipLocal = false, stringLike = ''}) async {
        return [];
      },
    );

_onPrepareExpenseAddToCartView(context, wholesale) {
  return (product, onAddToCart) {
    addExpenseToCartView(
      onGetPrice: (product) {
        return doubleOrZero('${product['purchase']}');
      },
      cart: CartModel(product: product, quantity: 1),
      onAddToCart: onAddToCart,
      context: context,
    );
  };
}
