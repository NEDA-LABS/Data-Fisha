import 'package:flutter/widgets.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/pages/sale_like.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/stocks.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/add_purchase_detail.dart';
import 'package:smartstock/stocks/components/add_purchase_to_cart.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/api_purchase.dart';
import 'package:smartstock/stocks/services/purchase.dart';
import 'package:smartstock/stocks/services/supplier.dart';

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
      wholesale: false,
      showDiscountView: false,
      title: 'Create purchase',
      backLink: '/stock/purchases',
      onBack: widget.onBackPage,
      customerLikeLabel: 'Choose supplier',
      onSubmitCart: _onSubmitPurchase,
      onGetPrice: _onGetPrice,
      onAddToCartView: _onSalesAddToCartView,
      onCustomerLikeList: getSupplierFromCacheOrRemote,
      onCustomerLikeAddWidget: () => const CreateSupplierContent(),
      checkoutCompleteMessage: 'Purchase complete.',
      onGetProductsLike: getStockFromCacheOrRemote,
    );
  }

  _onSalesAddToCartView(product, onAddToCart) {
    addPurchaseToCartView(
      onGetPrice: _onGetPrice,
      cart: CartModel(product: product, quantity: 1),
      onAddToCart: onAddToCart,
      context: context,
    );
  }

  _onGetPrice(product) {
    return doubleOrZero('${product['purchase']}');
  }

  Future<Map> _carts2Purchase(List carts, supplier, batchId, pDetail) async {
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
      "supplier": {"name": supplier},
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
            "supplier": supplier
          },
          "amount": doubleOrZero('${e.product['purchase']}') *
              doubleOrZero(e.quantity),
          "purchase": e.product['purchase'],
          "quantity": e.quantity
        };
      }).toList()
    };
  }

  Future _onSubmitPurchase(List carts, String customer, discount) async {
    if (customer.isEmpty) throw "Supplier required";
    String batchId = generateUUID();
    var shop = await getActiveShop();
    Map? pDetail;
    List<FileData?> file = [];
    await addPurchaseDetail(
        context: context,
        onSubmit: (state, List<FileData?> platformFile) {
          pDetail = state;
          file = platformFile;
          Navigator.of(context).maybePop();
        });
    if (pDetail is! Map) {
      throw 'Purchase details ( reference, date, due and type ) required';
    }
    var purchase = await _carts2Purchase(carts, customer, batchId, pDetail);
    return uploadFileToWeb3(file).then((fileResponse) {
      return productsPurchaseCreateRestAPI({
        ...purchase,
        'images': fileResponse.map((e) => e['link'] ?? '').toList()
      }, shop);
    });
  }
}
