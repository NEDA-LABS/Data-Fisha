import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like_page.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/types/OnAddToCartSubmitCallback.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/add_purchase_to_cart.dart';

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
  @override
  Widget build(BuildContext context) {
    return SaleLikePage(
      onQuickItem: (onAddToCartSubmitCallback) {
        _onAddToCart({}, onAddToCartSubmitCallback);
      },
      wholesale: false,
      title: 'Create purchase',
      // backLink: '/stock/purchases',
      onBack: widget.onBackPage,
      // customerLikeLabel: 'Choose supplier',
      // onSubmitCart: _onSubmitPurchase,
      onGetPrice: _onGetPrice,
      onAddToCart: _onAddToCart,
      // onCustomerLikeList: getSupplierFromCacheOrRemote,
      // onCustomerLikeAddWidget: () => const CreateSupplierContent(),
      // checkoutCompleteMessage: 'Purchase complete.',
      onGetProductsLike: getStockFromCacheOrRemote,
      onCheckout: (List<CartModel> carts) {
        if (kDebugMode) {
          print('------');
          print('Purchase checkout');
          print('------');
        }
      },
    );
  }

  _onAddToCart(Map product, OnAddToCartSubmitCallback submitCallback) {
    showDialogOrFullScreenModal(
      AddPurchase2CartDialogContent(
        onGetPrice: _onGetPrice,
        cart: CartModel(product: product, quantity: 1),
        onAddToCartSubmitCallback: (cart) {
          submitCallback(cart);
          Navigator.of(context).maybePop();
        },
      ),
      context,
    );
  }

  _onGetPrice(product) {
    return doubleOrZero('${product['purchase']}');
  }

  Future<Map> _carts2Purchase(
      List<CartModel> carts, Map supplier, batchId, pDetail) async {
    var currentUser = await getLocalCurrentUser();
    var t =
        '${cartTotalAmount(carts, false, (product) => product['purchase'])}';
    var totalAmount = doubleOrZero(t);
    var due = pDetail['due'];
    var type = pDetail['type'];
    var refNumber = pDetail['reference'];
    String? date = pDetail['date'];
    String? dueDate = date;
    if (type == 'invoice' && ((due is String && due.isEmpty) || due == null)) {
      dueDate = toSqlDate(DateTime.now().add(const Duration(days: 30)));
    }
    if (type == 'invoice' && (due is String && due.isNotEmpty)) {
      dueDate = due;
    }
    return {
      "date": date,
      "due": dueDate,
      "refNumber": refNumber,
      "batchId": batchId,
      "amount": totalAmount,
      "supplier": {"name": supplier['name'] ?? 'general'},
      "user": {"username": currentUser['username'] ?? ''},
      "type": type ?? 'receipt',
      "items": carts.map((e) {
        return {
          "wholesalePrice": e.product['wholesalePrice'],
          "retailPrice": e.product['retailPrice'],
          "expire": e.product['expire'],
          "product": {
            "id": e.product['id'],
            "product": e.product['product'],
            "stockable": e.product['stockable'] == true,
            "purchase": e.product['purchase'],
            "supplier": supplier['name'] ?? 'general'
          },
          "amount": doubleOrZero('${e.product['purchase']}') *
              doubleOrZero(e.quantity),
          "purchase": e.product['purchase'],
          "quantity": e.quantity
        };
      }).toList()
    };
  }

  Future _onSubmitPurchase(List carts, Map customer, discount) async {
    // if ('${customer['name'] ?? ''}'.isEmpty) throw "Supplier required";
    // String batchId = generateUUID();
    // var shop = await getActiveShop();
    // Map? pDetail;
    // List<FileData?> file = [];
    // await showDialogOrFullScreenModal(AddPurchaseDetailContent(
    //   onSubmit: (states, files) {
    // if (pDetail is! Map) {
    //   throw 'Purchase details ( reference, date, due and type ) required';
    // }
    // var purchase = await _carts2Purchase(carts, customer, batchId, pDetail);
    // return uploadFileToWeb3(file).then((fileResponse) {
    //   return productsPurchaseCreateRestAPI({
    //     ...purchase,
    //     'images': fileResponse.map((e) => e['link'] ?? '').toList()
    //   }, shop);
    // });
    // },
    // ), context);
    // await addPurchaseDetail(
    //     context: context,
    //     onSubmit: (state, List<FileData?> platformFile) {
    //       pDetail = state;
    //       file = platformFile;
    //       Navigator.of(context).maybePop();
    //     });
  }
}
