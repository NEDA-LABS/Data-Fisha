import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/PrimaryAction.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/cart_drawer.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/types/OnAddToCart.dart';
import 'package:smartstock/core/types/OnCheckout.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/core/types/OnGetProductsLike.dart';
import 'package:smartstock/core/types/OnQuickItem.dart';
import 'package:smartstock/sales/models/cart.model.dart';

class SaleLikePage extends StatefulWidget {
  final String title;
  final bool wholesale;
  final OnGetPrice onGetPrice;
  final OnAddToCart onAddToCart;
  final OnQuickItem onQuickItem;
  final OnCheckout onCheckout;
  final TextEditingController? searchTextController;
  final OnGetProductsLike onGetProductsLike;
  final VoidCallback? onBack;

  const SaleLikePage({
    required this.title,
    required this.wholesale,
    required this.onCheckout,
    required this.onGetPrice,
    required this.onAddToCart,
    required this.onQuickItem,
    this.onBack,
    this.searchTextController,
    required this.onGetProductsLike,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleLikePage> {
  String _query = '';
  bool _loading = false;
  List _items = [];
  List<CartModel> _carts = [];
  Map _shop = {};

  // StreamSubscription<Position>? _locationSubscriptionStream;

  @override
  void initState() {
    _initialLoad();
    getActiveShop().then((value) {
      _updateState(() {
        _shop = value;
      });
    }).catchError((e) {});
    // _locationSubscriptionStream =
    //     getLocationChangeStream().listen((Position? position) {
    //   if (position != null) {
    //     updateShopLocation(
    //       latitude: position.latitude.toString(),
    //       longitude: position.longitude.toString(),
    //     ).then((value) {
    //       if (kDebugMode) {
    //         print(value);
    //       }
    //     }).catchError((error) {
    //       if (kDebugMode) {
    //         print(error);
    //       }
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(var context) {
    var isSmallScreen = getIsSmallScreen(context);
    return Stack(children: [
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: ResponsivePage(
          office: 'Menu',
          sliverAppBar: _appBar(),
          rightDrawer: SizedBox(width: 320, child: _cartDrawer((p0) {})),
          backgroundColor: Theme.of(context).colorScheme.surface,
          staticChildren: [
            _loading ? const LinearProgressIndicator() : const SizedBox(),
            isSmallScreen ? const WhiteSpacer(height: 16) : const SizedBox(),
            isSmallScreen
                ? PrimaryAction(
                    text: 'Quick item',
                    onPressed: () {
                      widget.onQuickItem(_onAddToCartCallback);
                    })
                : getTableContextMenu([
                    ContextMenu(name: 'Quick item', pressed: () {
                      widget.onQuickItem(_onAddToCartCallback);
                    }),
                    ContextMenu(name: 'Reload', pressed: () => _refresh(true)),
                  ]),
            // DisplayTextSmall(text: 'Items'),
            // HorizontalLine(),
            isSmallScreen || _items.isEmpty ? Container() : _tableHeader(),
            _items.isEmpty && !_loading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const WhiteSpacer(height: 16),
                        BodyLarge(
                          text: _query.isNotEmpty
                              ? 'Sorry, filter "$_query" does not match any data.\n'
                                  'Please clear filter or refresh'
                              : 'No pre-saved products found. Use "Quick Item" to add to cart or refresh',
                        ),
                        const WhiteSpacer(height: 8),
                        InkWell(
                          hoverColor: Colors.transparent,
                          onTap: _initialLoad,
                          child: BodyLarge(
                            text: 'Refresh data',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            isSmallScreen ? const WhiteSpacer(height: 16) : const SizedBox(),
          ],
          dynamicChildBuilder: isSmallScreen
              ? (a, b) => _smallScreenChildBuilder(a, b)
              : (a, b) => _largerScreenChildBuilder(a, b),
          totalDynamicChildren: _items.length,
          fab: isSmallScreen && _carts.isEmpty ? _fab() : null,
          // onBody: (drawer) {
          //   return NestedScrollView(
          //     headerSliverBuilder: (context, innerBoxIsScrolled) {
          //       return [
          //         _states['hab'] == true ? Container() : _appBar(_updateState)
          //       ];
          //     },
          //     body: Scaffold(
          //       // floatingActionButton: _fab(),
          //       backgroundColor: Theme.of(context).colorScheme.surface,
          //       body: FutureBuilder<List>(future: _future(), builder: _getView),
          //     ),
          //   );
          // },
        ),
      ),
      isSmallScreen && _carts.isNotEmpty
          ? Positioned(bottom: 16, left: 16, right: 16, child: _cartPreview())
          : const Positioned(left: 0, child: SizedBox())
    ]);
  }

  _tableHeader() {
    return const TableLikeListRow([
      LabelSmall(text: 'ITEM NAME'),
      // LabelSmall(text:'QUANTITY'),
      // LabelSmall(text: 'COST ( ${shop['settings']?['currency']??''} )'),
      LabelSmall(text: 'CATEGORY'),
      Center(child: LabelSmall(text: "VALUE")),
      Center(child: LabelSmall(text: "ACTION")),
    ]);
  }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            widget.onAddToCart(_items[index], _onAddToCartCallback);
          },
          child: TableLikeListRow([
            TableLikeListTextDataCell(
                firstLetterUpperCase('${_items[index]['product']}')),
            TableLikeListTextDataCell('${_items[index]['category']}'),
            Center(
              child: TableLikeListTextDataCell(
                  '${_shop['settings']?['currency'] ?? ''} ${formatNumber('${widget.onGetPrice(_items[index])}')}'),
            ),
            // TableLikeListTextDataCell(
            //     '${formatNumber(_items[index]['purchase'])}'),
            // _renderStockStatus(_items[index]),
            // Container()
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LabelLarge(
                  text: 'Select',
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          onTap: () {
            widget.onAddToCart(_items[index], _onAddToCartCallback);
          },
          title: BodyLarge(
              text: firstLetterUpperCase('${_items[index]['product']}')),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WhiteSpacer(height: 4),
              LabelLarge(
                text:
                    '${_shop['settings']?['currency'] ?? ''} ${formatNumber(_items[index]['purchase'])}',
              ),
              LabelMedium(text: _items[index]['category'])
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelLarge(
                text: 'Select',
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).colorScheme.primary,
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
          // dense: true,
        ),
        const SizedBox(height: 5),
        const HorizontalLine(),
      ],
    );
  }

  // List<CartModel> _getCarts(Map data) {
  //   List<CartModel> carts = itOrEmptyArray(data['carts']);
  //   return carts;
  // }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  // _hasCarts(states) => _getCarts(states).isNotEmpty;

  _onAddToCartCallback(CartModel cart) {
    List<CartModel> carts = appendToCarts(cart, _carts);
    _updateState(() {
      _carts = carts;
    });
    // Navigator.of(context).maybePop();
  }

  _onShowCartSheet() {
    showFullScreeDialog(context, (refresh) => _cartDrawer(refresh));
  }

  _appBar() {
    return SliverSmartStockAppBar(
      title: widget.title,
      searchTextController: widget.searchTextController,
      showBack: true,
      showSearch: true,
      searchHint: "Search here...",
      onBack: widget.onBack,
      onSearch: (text) {
        if (text.startsWith('qr_code:')) {
          var barCodeQ = text.replaceFirst('qr_code:', '');
          widget
              .onGetProductsLike(skipLocal: false, stringLike: barCodeQ)
              .then((value) {
            Map? inventory = itOrEmptyArray(value).firstWhere((element) {
              var getBarCode = propertyOrNull('barcode');
              var barCode = getBarCode(element);
              return barCode == barCodeQ && barCodeQ != '' && barCodeQ != '_';
            }, orElse: () => null);
            if (inventory != null) {
              widget.onAddToCart(inventory, _onAddToCartCallback);
            }
          }).catchError((e) {});
        } else {
          _query = text;
          _refresh(false, _query);
        }
      },
      context: context,
    );
  }

  _fab() {
    return FloatingActionButton(
      onPressed: () => _showMobileContextMenu(context),
      child: const Icon(Icons.unfold_more_outlined),
    );
  }

  void _showMobileContextMenu(context) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const BodyLarge(text: 'Quick item'),
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete((){
                    widget.onQuickItem(_onAddToCartCallback);
                  });
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload'),
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete((){
                    _refresh(true);
                  });
                },
              ),
            ],
          ),
        ),
        context);
  }

  // Widget _getView(context, snapshot) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       // _isLoading(snapshot)
  //       //     ? const LinearProgressIndicator()
  //       //     : const SizedBox(),
  //       snapshot is AsyncSnapshot && snapshot.hasError
  //           ? BodyLarge(text: "${snapshot.error}")
  //           : const SizedBox(),
  //       // const LabelSmall(text: 'PRODUCTS'),
  //       Expanded(
  //         child: SalesLikeBody(
  //           onAddToCart: _onAddToCartCallback,
  //           wholesale: widget.wholesale,
  //           products: snapshot.data ?? [],
  //           onAddToCartView: widget.onAddToCart,
  //           onShowCart: _onShowCartSheet,
  //           onGetPrice: widget.onGetPrice,
  //           carts: _carts,
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _cartPreview() {
    return PrimaryAction(
      text: 'Cart [ ${_getTotalItems(_carts)} Items ]',
      onPressed: _onShowCartSheet,
    );
  }

  _getTotalItems(List<dynamic> carts) {
    return carts.fold(0, (dynamic a, element) => a + element.quantity);
  }

  Widget _cartDrawer(void Function(VoidCallback) refresh) {
    return CartDrawer(
      // showCustomerLike: widget.showCustomerLike,
      // customerLikeLabel: widget.customerLikeLabel,
      onAddItem: (id, q) {
        _prepareAddCartQuantity(id, q);
        refresh(() {});
      },
      onRemoveItem: (id) {
        _prepareRemoveCart(id);
        if (_carts.isNotEmpty) {
          refresh(() {});
        } else {
          if (getIsSmallScreen(context)) {
            Navigator.of(context).maybePop();
          }
        }
      },
      onCartCheckout: () {
        // Map customer = states['customer'] is Map ? states['customer'] : {};
        // var carts = states['carts'];
        // return widget.onSubmitCart(carts, customer, discount).then((value) {
        // updateState({'carts': [], 'customer': ''});
        // Navigator.of(context).maybePop().whenComplete(() {
        //   showInfoDialog(context, widget.checkoutCompleteMessage);
        // });
        // }).catchError(_showCheckoutError(context));
        widget.onCheckout(_carts);
      },
      carts: _carts,
      // showDiscountView: widget.showDiscountView,
      wholesale: widget.wholesale,
      // customer: _getCustomer(states),
      // onCustomerLikeList: widget.onCustomerLikeList,
      // onCustomerLikeAddWidget: widget.onCustomerLikeAddWidget,
      // onCustomer: (d) => updateState({"customer": d}),
      onGetPrice: widget.onGetPrice,
    );
  }

  _prepareRemoveCart(String id) {
    var carts = removeCart(id, _carts);
    _updateState(() {
      _carts = carts;
    });
  }

  _prepareAddCartQuantity(String id, dynamic quantity) {
    var carts = updateCartQuantity(id, quantity, _carts);
    _updateState(() {
      _carts = carts;
    });
  }

  @override
  void dispose() {
    // if (_locationSubscriptionStream != null) {
    //   _locationSubscriptionStream?.cancel();
    // }
    super.dispose();
  }

  void _refresh([skip = false, q = '']) {
    setState(() {
      _loading = true;
    });
    widget.onGetProductsLike(skipLocal: skip, stringLike: q).then((value) {
      _items = value;
    }).catchError((error) {
      showInfoDialog(context, error);
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  void _initialLoad() {
    setState(() {
      _loading = true;
    });
    widget
        .onGetProductsLike(skipLocal: false, stringLike: _query)
        .then((value) {
      if (itOrEmptyArray(value).isEmpty) {
        return widget.onGetProductsLike(
          skipLocal: true,
          stringLike: '',
        );
      } else {
        return value;
      }
    }).then((value) {
      _items = itOrEmptyArray(value);
    }).catchError((error) {
      showInfoDialog(context, error);
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}
