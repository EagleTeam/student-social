import 'package:action_mixin/action_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_code/lazy_code.dart';

import '../../../events/alert.dart';
import '../../../events/alert_chon_kyhoc.dart';
import '../../../events/loading_message.dart';
import '../../../events/pop.dart';
import '../../../events/save_success.dart';
import '../../../helpers/dialog_support.dart';
import 'login_notifier.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginNotifier _loginNotifier;
  FocusNode textSecondFocusNode = FocusNode();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginNotifier = LoginNotifier();
    _loginNotifier.initActions(actions());
    _loginNotifier.initActionUpdate(actions());
  }

  List<ActionEntry> actions() {
    return [
      ActionEntry(event: const EventPop(), action: (_) => pop(context)),
      ActionEntry(
          event: const EventLoadingMessage(),
          action: (event) {
            if (event is EventLoadingMessage) {
              loadingMessage(context, event.message);
            }
          }),
      ActionEntry(
          event: const EventAlert(),
          action: (event) {
            if (event is EventAlert) {
              showAlertMessage(context, event.message);
            }
          }),
      ActionEntry(
          event: const EventAlertChonKyHoc(),
          action: (event) {
            if (event is EventAlertChonKyHoc) {
              _loginNotifier.showAlertChonKyHoc(context, event.semesterResult);
            }
          }),
      ActionEntry(
          event: const EventSaveSuccess(),
          action: (event) {
            if (event is EventSaveSuccess) {
              saveSuccess();
            }
          }),
    ];
  }

  Future<void> saveSuccess() async {
    await showSuccess(context, 'Đăng nhập hoàn tất');
  }

  Widget get logo => const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80,
        backgroundImage: AssetImage('image/Logo.png'),
      );

  Widget email() {
    return TextField(
        controller: controllerEmail,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(textSecondFocusNode);
        },
        decoration: _Decoration(
          label: 'Mã sinh viên',
          prefixIcon: const Icon(Icons.account_circle),
        ));
  }

  Widget password() {
    return TextField(
        focusNode: textSecondFocusNode,
        controller: controllerPassword,
        obscureText: true,
        onSubmitted: (value) => _submit(),
        decoration: _Decoration(
          label: 'Mật khẩu',
          prefixIcon: const Icon(Icons.lock),
        ));
  }

  Widget loginButton() {
    return Row(
      children: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Xong',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.topRight,
          child: RaisedButton(
            onPressed: _submit,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.green,
            child: const Text('Thêm',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo,
                const Padding(padding: EdgeInsets.only(top: 16)),
                const Text('Student Social',
                    style: TextStyle(color: Colors.black, fontSize: 40)),
                const Padding(padding: EdgeInsets.only(top: 48)),
                email(),
                const Padding(padding: EdgeInsets.only(top: 12)),
                password(),
                const Padding(padding: EdgeInsets.only(top: 24)),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    _loginNotifier.submit(controllerEmail.text, controllerPassword.text);
  }
}

class _Decoration extends InputDecoration {
  _Decoration({String label, Widget prefixIcon})
      : super(
          labelText: label,
          prefixIcon: prefixIcon,
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        );
}
