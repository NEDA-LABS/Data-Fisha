import 'package:flutter/material.dart';
import 'package:smartstock/account/services/profile.dart';
import 'package:smartstock/core/components/PrimaryAction.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/services/cache_user.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileForm> {
  var isReady = false;
  var loading = false;
  var state = {};

  updateState(map) {
    map is Map
        ? setState(() {
            state.addAll(map);
          })
        : null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isReady = true;
    });
    getLocalCurrentUser()
        .then((value) {
          state['fullname'] =
              '${value['firstname'] ?? ''} ${value['lastname']}';
          updateState(value);
        })
        .catchError((err) {})
        .whenComplete(() {
          setState(() {
            isReady = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return isReady
        ? Container()
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextInput(
                      initialText: '${state['username'] ?? ''}',
                      label: 'Username',
                      readOnly: true,
                      onText: (v) => updateState({'username': v}),
                    ),
                    TextInput(
                      initialText:
                          '${state['firstname'] ?? ''} ${state['lastname'] ?? ''}',
                      label: 'Fullname',
                      readOnly: false,
                      error: '${state['fullname_e'] ?? ''}',
                      onText: (v) =>
                          updateState({'fullname': v, 'fullname_e': ''}),
                    ),
                    TextInput(
                      initialText: '${state['mobile'] ?? ''}',
                      label: 'Mobile',
                      readOnly: false,
                      error: '${state['mobile_e'] ?? ''}',
                      onText: (v) => updateState({'mobile': v, 'mobile_e': ''}),
                    ),
                    TextInput(
                      initialText: '${state['email'] ?? ''}',
                      label: 'Email',
                      // placeholder: 'start with 255',
                      readOnly: true,
                      onText: (v) => updateState({'email': v}),
                    ),
                    TextInput(
                      initialText: '${state['emails'] ?? ''}',
                      label: 'Other emails',
                      readOnly: false,
                      placeholder: 'Comma separated',
                      error: '${state['emails_e'] ?? ''}',
                      onText: (v) => updateState({'emails': v, 'emails_e': ''}),
                    ),
                    const SizedBox(height: 16),
                    PrimaryAction(
                      text: loading ? "Waiting..." : "Update",
                      onPressed: loading ? null : _onPressed,
                    )
                  ],
                ),
              ),
            ),
          );
  }

  _onPressed() {
    String fullname = state['fullname'] ?? '';
    var mobile = state['mobile'];
    var emails = state['emails'] ?? '';
    // if (!(fullname is String && fullname.isNotEmpty)) {
    //   updateState({'fullname_e': 'Field required'});
    // }
    if (!(mobile is String && mobile.isNotEmpty)) {
      updateState({'mobile_e': 'Field required'});
      return;
    }
    setState(() {
      loading = true;
    });
    updateProfileDetails({
      "emails": emails,
      "mobile": mobile,
      "firstname": fullname.replaceAll('.', ''),
      "lastname": '.'
    }).then((value) {
      showTransactionCompleteDialog(context, "Details updated",canDismiss: true);
    }).catchError((err) {
      showTransactionCompleteDialog(context, err, title: 'Error!',canDismiss: true);
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
