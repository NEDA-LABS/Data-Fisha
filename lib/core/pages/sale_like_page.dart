import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
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
import 'package:smartstock/core/services/api_shop.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/location.dart';
import 'package:smartstock/core/types/OnAddToCart.dart';
import 'package:smartstock/core/types/OnCheckout.dart';
import 'package:smartstock/core/types/OnGetPrice.dart';
import 'package:smartstock/core/types/OnGetProductsLike.dart';
import 'package:smartstock/core/types/OnQuickItem.dart';
import 'package:smartstock/sales/models/cart.model.dart';

class SaleLikePage extends StatefulWidget {
  final String title;
  final bool wholesale;
  final OnGetPrice onGetRetailPrice;
  final OnGetPrice? onGetWholesalePrice;
  final OnAddToCart onAddToCart;
  final OnQuickItem? onQuickItem;
  final OnCheckout onCheckout;
  final TextEditingController? searchTextController;
  final OnGetProductsLike onGetProductsLike;
  final VoidCallback? onBack;

  const SaleLikePage({
    required this.title,
    required this.wholesale,
    required this.onCheckout,
    required this.onGetRetailPrice,
    this.onGetWholesalePrice,
    required this.onAddToCart,
    this.onQuickItem,
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
  // Map _shop = {};

  StreamSubscription<Position>? _locationSubscriptionStream;

  @override
  void initState() {
    _initialLoad();
    // getActiveShop().then((value) {
    //   _updateState(() {
    //     _shop = value;
    //   });
    // }).catchError((e) {});
    _locationSubscriptionStream =
        getLocationChangeStream().listen((Position? position) {
      if (position != null) {
        updateShopLocation(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        ).then((value) {
          if (kDebugMode) {
            print(value);
          }
        }).catchError((error) {
          if (kDebugMode) {
            print(error);
          }
        });
      }
    });
    widget.searchTextController?.addListener(() {
      if (widget.searchTextController?.value.text.isEmpty == true) {
        _refresh(false);
      }
    });
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
                ? widget.onQuickItem != null
                    ? PrimaryAction(
                        text: 'Quick item',
                        onPressed: () {
                          widget.onQuickItem!(_onAddToCartCallback);
                        })
                    : Container()
                : getTableContextMenu(widget.onQuickItem != null
                    ? [
                        ContextMenu(
                            name: 'Quick item',
                            pressed: () {
                              widget.onQuickItem!(_onAddToCartCallback);
                            }),
                        ContextMenu(
                            name: 'Reload', pressed: () => _refresh(true)),
                      ]
                    : [
                        ContextMenu(
                            name: 'Reload', pressed: () => _refresh(true))
                      ]),
            // isSmallScreen || _items.isEmpty ? Container() : _tableHeader(),
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
                              : 'No pre-saved waste category found. Use "Quick Item" to add to cart or refresh',
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
          dynamicChildBuilder: _largerScreenChildBuilder,
          totalDynamicChildren: _items.length,
          fab: isSmallScreen && _carts.isEmpty ? _fab() : null,
        ),
      ),
      isSmallScreen && _carts.isNotEmpty
          ? Positioned(bottom: 16, left: 16, right: 16, child: _cartPreview())
          : const Positioned(left: 0, child: SizedBox())
    ]);
  }

  // _tableHeader() {
  //   return TableLikeListRow([
  //     const LabelSmall(text: 'ITEM NAME'),
  //     // LabelSmall(text:'QUANTITY'),
  //     // LabelSmall(text: 'COST ( ${shop['settings']?['currency']??''} )'),
  //     // const LabelSmall(text: 'QUANTITY'),
  //     // Center(
  //     //     child: LabelSmall(
  //     //         text:
  //     //             "PRICE\n( ${_shop['settings']?['currency'] ?? ''} )")),
  //     // widget.onGetWholesalePrice != null
  //     //     ? Center(
  //     //         child: LabelSmall(
  //     //             text:
  //     //                 "WHOLE PRICE\n( ${_shop['settings']?['currency'] ?? ''} )"))
  //     //     : Container(),
  //     const Center(child: LabelSmall(text: "ACTION")),
  //   ]);
  // }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => widget.onAddToCart(_items[index], _onAddToCartCallback),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 100,
                    height: 70,
                    child: Image.network(
                      '${_items[index]['image']}',
                      errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ),
                const WhiteSpacer(width: 16),
                BodyLarge(text:
                    firstLetterUpperCase('${_items[index]['name']}')),
                const Expanded(child: WhiteSpacer(width: 16)),
                LabelLarge(
                  text: 'Select',
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //
                //   ],
                // ),
              ]),
              const WhiteSpacer(height: 8)
            ],
          ),
        ),
        const HorizontalLine(),
        const WhiteSpacer(height: 8)
      ],
    );
  }

  // Widget _smallScreenChildBuilder(context, index) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       ListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 5),
  //         onTap: () {
  //           widget.onAddToCart(_items[index], _onAddToCartCallback);
  //         },
  //         title:
  //             BodyLarge(text: firstLetterUpperCase('${_items[index]['name']}')),
  //         subtitle: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const BodyMedium(text: 'Qty : '),
  //             _getQuantityLabel(_items[index])
  //           ],
  //         ),
  //         trailing: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             BodyLarge(
  //               text:
  //                   '${_shop['settings']?['currency'] ?? ''} ${formatNumber(widget.onGetRetailPrice(_items[index]))}',
  //             ),
  //             Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 LabelLarge(
  //                   text: 'Select',
  //                   overflow: TextOverflow.ellipsis,
  //                   color: Theme.of(context).colorScheme.primary,
  //                 ),
  //                 Icon(
  //                   Icons.chevron_right,
  //                   color: Theme.of(context).primaryColor,
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //         // dense: true,
  //       ),
  //       const SizedBox(height: 5),
  //       const HorizontalLine(),
  //     ],
  //   );
  // }

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
        // if (text.startsWith('qr_code:')) {
        //   var barCodeQ = text.replaceFirst('qr_code:', '');
        //   widget.onGetProductsLike(false, barCodeQ).then((value) {
        //     Map? inventory = itOrEmptyArray(value).firstWhere((element) {
        //       var getBarCode = propertyOrNull('barcode');
        //       var barCode = getBarCode(element);
        //       return barCode == barCodeQ && barCodeQ != '' && barCodeQ != '_';
        //     }, orElse: () => null);
        //     if (inventory != null) {
        //       widget.onAddToCart(inventory, _onAddToCartCallback);
        //     }
        //   }).catchError((e) {});
        // } else {
          if (text.isNotEmpty) {
            _query = text;
            _refresh(false, _query);
          }
        // }
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
              widget.onQuickItem != null
                  ? ListTile(
                      leading: const Icon(Icons.add),
                      title: const BodyLarge(text: 'Quick item'),
                      onTap: () {
                        Navigator.of(context).maybePop().whenComplete(() {
                          widget.onQuickItem!(_onAddToCartCallback);
                        });
                      },
                    )
                  : Container(),
              widget.onQuickItem != null ? const HorizontalLine() : Container(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload'),
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(() {
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

  _clearCart() {
    _updateState(() {
      _carts = [];
    });
  }

  Widget _cartDrawer(void Function(VoidCallback) refresh) {
    return CartDrawer(
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
        if (getIsSmallScreen(context)) {
          Navigator.of(context).maybePop().whenComplete(() {
            widget.onCheckout(_carts, _clearCart);
          });
        } else {
          widget.onCheckout(_carts, _clearCart);
        }
      },
      carts: _carts,
      wholesale: widget.wholesale,
      onGetPrice: widget.onGetRetailPrice,
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
    // widget.searchTextController?.dispose();
    // if (_locationSubscriptionStream != null) {
    _locationSubscriptionStream?.cancel();
    // }
    super.dispose();
  }

  void _refresh([skip = false, q = '']) {
    setState(() {
      _loading = true;
    });
    widget.onGetProductsLike(skip, q).then((value) {
      _items = value;
    }).catchError((error) {
      showTransactionCompleteDialog(context, error,
          canDismiss: true, title: 'Error');
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
    widget.onGetProductsLike(false, _query).then((value) {
      if (itOrEmptyArray(value).isEmpty) {
        return widget.onGetProductsLike(true, '');
      } else {
        return value;
      }
    }).then((value) {
      _items = itOrEmptyArray(value);
    }).catchError((error) {
      showTransactionCompleteDialog(context, error,
          canDismiss: true, title: 'Error');
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  // Widget _getQuantityLabel(item) {
  //   var quantity = doubleOrZero(item?['quantity'] ?? '');
  //   var stockable = item?['stockable'] == true;
  //   // var pc = Theme.of(context).colorScheme.primary;
  //   var ec = Theme.of(context).colorScheme.error;
  //   return BodyMedium(
  //     text: stockable ? '${formatNumber(quantity)}' : 'n/a',
  //     color: stockable ? (quantity <= 0 ? ec : null) : null,
  //   );
  // }
}
