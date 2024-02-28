import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TextAreaInput.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/expense/components/create_category_form.dart';
import 'package:smartstock/expense/services/categories.dart';
import 'package:smartstock/expense/services/expenses.dart';

class CreateExpenseForm extends StatefulWidget {
  final VoidCallback onDone;

  const CreateExpenseForm({super.key, required this.onDone});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateExpenseForm> {
  Map _shop = {};
  bool _confirming = false;
  final Map _errors = {};
  String _date = '';
  String _amount = '';
  String _narration = '';
  Map _category = {};

  // Map state = {
  //   "item": "",
  //   "date": "",
  //   "item_err": "",
  //   "category": "",
  //   "category_err": "",
  //   "amount": "",
  //   "amount_err": "",
  //   "req_err": ""
  // };
  List<FileData?> _filesData = [];

  _getDateInput() {
    return DateInput(
        onText: (d) {
          _updateState(() {
            _date = d;
            _errors['date'] = '';
          });
        },
        label: 'Date',
        error: '${_errors['date'] ?? ''}',
        firstDate: DateTime.now().subtract(const Duration(days: 360 * 2)),
        initialDate: DateTime.now(),
        lastDate: DateTime.now());
  }

  _getCategoryInput() {
    return ChoicesInput(
      choice: _category,
      label: "Category",
      placeholder: "Click to select",
      error: '${_errors['category'] ?? ''}',
      onChoice: (d) {
        _updateState(() {
          _category = d;
          _errors['category'] = '';
        });
      },
      onLoad: getExpenseCategoriesFromCacheOrRemote,
      onField: (p0) => '${p0 is Map ? p0['name'] ?? '' : p0 ?? ''}',
      getAddWidget: () => const CreateExpenseCategoryForm(),
    );
  }

  _getNarrationInput() {
    return TextAreaInput(
      error: '${_errors['narration'] ?? ''}',
      onText: (d) {
        _updateState(() {
          _narration = d;
          _errors['narration'] = '';
        });
      },
    );
  }

  _getAmountInput() {
    return TextInput(
      onText: (d) {
        _updateState(() {
          _amount = d;
          _errors['amount'] = '';
        });
      },
      label: "Amount",
      error: '${_errors['amount'] ?? ''}',
      type: TextInputType.number,
    );
  }

  @override
  void initState() {
    getActiveShop().then((value) {
      _updateState(() {
        _shop = value;
      });
    }).catchError((e) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_confirming,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getHeaderSection(top: 16),
          const WhiteSpacer(height: 8),
          const HorizontalLine(),
          Expanded(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [SliverToBoxAdapter(child: _getDetailSection(top: 8))],
            ),
          ),
          const HorizontalLine(),
          _getFooterSection(top: 16)
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(16),
    //   child: SingleChildScrollView(
    //     child: ListBody(
    //       children: [
    //         CardRoot(
    //             child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             _getDateInput(),
    //             _getCategoryInput(),
    //           ],
    //         )),
    //         const WhiteSpacer(height: 16),
    //         CardRoot(
    //             child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             const BodyMedium(text: 'Narration / Details'),
    //             _getNarrationInput(),
    //             _getAmountInput(),
    //           ],
    //         )),
    //         const WhiteSpacer(height: 16),
    //         CardRoot(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               const Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 16.0),
    //                 child: LabelLarge(text: 'Receipts'),
    //               ),
    //               FileSelect(
    //                 onFiles: (file) {
    //                   if (mounted) {
    //                     _filesData = file;
    //                   }
    //                 },
    //               )
    //             ],
    //           ),
    //         ),
    //         const WhiteSpacer(height: 16),
    //         PrimaryAction(
    //           text: state['creating'] == true ? "Waiting..." : "Save expense",
    //           onPressed: state['creating'] == true ? () {} : _onPressed,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  // _updateMapState(map) {
  //   if (map is Map) {
  //     if (mounted) {
  //       setState(() {
  //         state.addAll(map);
  //       });
  //     }
  //   }
  // }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  Widget _sectionWrapper({
    required Widget child,
    required double top,
    Color? color,
    double radius = 0,
  }) {
    var hPadding = EdgeInsets.only(left: 24, right: 24, top: top);
    return Container(
      margin: hPadding,
      decoration: BoxDecoration(
        border: color != null ? Border.all(color: color) : null,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: child,
    );
  }

  _getHeaderSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var manageSaleTitle = const BodyLarge(text: 'Create expense');
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [manageSaleTitle],
            )
          : Row(
              children: [
                manageSaleTitle,
                const Expanded(child: SizedBox()),
                // createdTitle
              ],
            ),
    );
  }

  _getFilesSection() {
    return FileSelect(
      onFiles: (file) {
        if (mounted) {
          _filesData = file;
        }
      },
    );
  }

  _validateForm() {
    bool valid = true;
    if (_narration.isEmpty) {
      valid = false;
      _errors['narration'] = 'Narration/Description required';
    }
    if ('${_category['name'] ?? ''}'.isEmpty) {
      valid = false;
      _errors['category'] = 'Category required';
    }
    if (_date.isEmpty) {
      valid = false;
      _errors['date'] = 'Expense date required';
    }
    if (_amount.isEmpty || doubleOrZero(_amount) <= 0) {
      valid = false;
      _errors['amount'] = 'Amount required and must be greater than zero';
    }
    _updateState(() {});
    return valid;
  }

  _onCreateExpense() {
    if (_validateForm()) {
      _updateState(() {
        _confirming = true;
      });
      uploadFileToWeb3(_filesData).then((fileResponse) {
        return submitExpenses(
          name: _narration,
          date: _date,
          category: _category['name'] ?? '',
          amount: doubleOrZero(_amount),
          file: fileResponse.map((e) {
            return {
              "link": e['link'] ?? '',
              "tags": 'receipt,expense,expenses',
            };
          }).toList(),
        );
      }).then((value) {
        showTransactionCompleteDialog(
          context,
          'Expense created successful',
          canDismiss: false,
          onClose: () {
            Navigator.of(context).maybePop().whenComplete(() {
              widget.onDone();
            });
          },
        );
      }).catchError((e) {
        showTransactionCompleteDialog(context, e,
            canDismiss: true, title: 'Error');
      }).whenComplete(() {
        _updateState(() {
          _confirming = false;
        });
      });
    }
  }

  _getFooterSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var buttons = CancelProcessButtonsRow(
      cancelText: _confirming ? null : "Cancel",
      proceedText: _confirming ? 'Saving...' : 'Save',
      onCancel: _confirming ? null : () => Navigator.of(context).maybePop(),
      onProceed: _confirming ? null : _onCreateExpense,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      child: isSmallScreen
          ? buttons
          : Row(children: [
              Expanded(flex: 3, child: Container()),
              Expanded(flex: 1, child: buttons)
            ]),
    );
  }

  _getSmallView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _getDateInput(),
        const WhiteSpacer(width: 16),
        _getCategoryInput(),
        const WhiteSpacer(width: 16),
        _getAmountInput(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: LabelLarge(text: 'Receipts'),
        ),
        _getFilesSection(),
        const WhiteSpacer(width: 16),
        _getNarrationInput(),
        const WhiteSpacer(height: 24),
      ],
    );
  }

  _getLargeView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _getDateInput()),
            const WhiteSpacer(width: 8),
            Expanded(child: _getCategoryInput()),
            const WhiteSpacer(width: 8),
            Expanded(child: _getAmountInput()),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: LabelLarge(text: 'Receipts'),
        ),
        _getFilesSection(),
        _getNarrationInput(),
        const WhiteSpacer(height: 24),
      ],
    );
  }

  _getDetailSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    return _sectionWrapper(
      top: top,
      child: isSmallScreen ? _getSmallView() : _getLargeView(),
    );
  }
}
