import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../helpers/dialog_support.dart';
import '../../../models/entities/semester.dart';
import 'login_notifier.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with DialogSupport {
  LoginNotifier _loginViewModel;
  FocusNode textSecondFocusNode = FocusNode();
  bool listened = false;
  final TextEditingController controllerEmail = TextEditingController();

  final TextEditingController controllerPassword = TextEditingController();

  void _initViewModel() {
    _loginViewModel = Provider.of<LoginNotifier>(context);
    if (!listened) {
      _loginViewModel.getActionStream().listen((value) async {
        if (value['type'] == LoginAction.pop) {
          pop(context);
        } else if (value['type'] == LoginAction.loading) {
          loading(context, value['data']);
        } else if (value['type'] == LoginAction.alert_with_message) {
          showAlertMessage(context, value['data']);
        } else if (value['type'] == LoginAction.alert_chon_kyhoc) {
          _showAlertChonKyHoc(value['data']);
        } else if (value['type'] == LoginAction.save_success) {
          saveSuccess();
        }
      });
      listened = true;
    }
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
      onSubmitted: (String value) {
        FocusScope.of(context).requestFocus(textSecondFocusNode);
      },
      decoration: InputDecoration(
        hintText: 'Mã sinh viên',
        labelText: 'Mã sinh viên',
        prefixIcon: const Icon(Icons.account_circle),
        suffixIcon: IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () {
              FocusScope.of(context).requestFocus(textSecondFocusNode);
            }),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget password() {
    return TextField(
      focusNode: textSecondFocusNode,
      controller: controllerPassword,
      obscureText: true,
      onSubmitted: (String value) {
        _loginViewModel.submit(controllerEmail.text, controllerPassword.text);
      },
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () {
              _loginViewModel.submit(
                  controllerEmail.text, controllerPassword.text);
            }),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
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
            onPressed: () {
              _loginViewModel.submit(
                  controllerEmail.text, controllerPassword.text);
            },
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
    _initViewModel();

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

  Widget _itemKyHoc(BuildContext context, Semester data) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Kỳ ${data.TenKy.split('_')[0]} năm ${data.TenKy.split('_')[1]}-${data.TenKy.split('_')[2]}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _loginViewModel.semesterClicked(data.MaKy);
              },
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(
              height: 1,
            )
          ],
        ));
  }

  void _showAlertChonKyHoc(SemesterResult data) {
    final AlertDialog alertDialog = AlertDialog(
      title: const Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.message.length,
                itemBuilder: (BuildContext buildContext, int index) =>
                    _itemKyHoc(context, data.message[index]),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
