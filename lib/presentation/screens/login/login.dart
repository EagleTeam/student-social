import 'package:action_mixin/action_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:studentsocial/events/alert.dart';
import 'package:studentsocial/events/alert_chon_kyhoc.dart';
import 'package:studentsocial/events/loading_message.dart';
import 'package:studentsocial/events/pop.dart';
import 'package:studentsocial/events/save_success.dart';

import '../../../helpers/dialog_support.dart';
import '../../../models/entities/semester.dart';
import 'login_notifier.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode textSecondFocusNode = FocusNode();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read(loginProvider).initActions(actions());
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
              _showAlertChonKyHoc(event.semesterResult);
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
        context
            .read(loginProvider)
            .submit(controllerEmail.text, controllerPassword.text);
      },
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () {
              context
                  .read(loginProvider)
                  .submit(controllerEmail.text, controllerPassword.text);
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
              context
                  .read(loginProvider)
                  .submit(controllerEmail.text, controllerPassword.text);
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
                context.read(loginProvider).semesterClicked(data.MaKy);
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
