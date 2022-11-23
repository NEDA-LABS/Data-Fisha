import 'package:flutter/widgets.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/expense/components/add_expense_to_cart.dart';
import 'package:smartstock/expense/services/expenses.dart';
import 'package:smartstock/expense/services/items.dart';
import 'package:smartstock/sales/models/cart.model.dart';

expenseCreatePage(BuildContext context) => SaleLikePage(
      wholesale: false,
      title: 'Create expense',
      backLink: '/expense/expenses',
      customerLikeLabel: '',
      onSubmitCart: prepareOnSubmitExpenses(context),
      showCustomerLike: false,
      onGetPrice: (_) => null,
      onAddToCartView: _onPrepareExpenseAddToCartView(context, false),
      onCustomerLikeList: ({skipLocal = false}) async => [],
      onCustomerLikeAddWidget: () => Container(),
      checkoutCompleteMessage: 'Expense recorded.',
      onGetProductsLike: getExpenseItemFromCacheOrRemote,
    );

_onPrepareExpenseAddToCartView(context, wholesale) {
  return (product, onAddToCart) {
    addExpenseToCartView(
      onGetPrice: (item) => null,
      cart: CartModel(product: product, quantity: 1),
      onAddToCart: onAddToCart,
      context: context,
    );
  };
}
