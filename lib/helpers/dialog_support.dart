import 'package:flutter/material.dart';
import 'package:studentsocial/helpers/logging.dart';

mixin DialogSupport {
  Future<void> loading(BuildContext context, String msg) {
    return showDialog(
      context: context,
      barrierDismissible: false, // không thể ẩn bằng cách bấm ra ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          contentPadding: const EdgeInsets.all(16),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: 30,
                  height: 30,
                  child:
                      const Center(child: const CircularProgressIndicator())),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(msg),
              )
            ],
          ),
        );
      },
    );
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> showSuccess(BuildContext context, String msg) async {
    final AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: const EdgeInsets.all(16),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(msg),
          )
        ],
      ),
    );
    await showDialog(context: context, builder: (_) => dialog);
    await Future.delayed(const Duration(milliseconds: 800));
    logs('hihi dang nhap hoan tat');
  }

  Future<void> showAlertMessage(BuildContext context, String msg) async {
    final dialog = AlertDialog(
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
    return showDialog(context: context, builder: (_) => dialog);
  }
}
