import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({
    this.data,
    this.size,
    this.padding = const EdgeInsets.all(70),
    this.backgroundColor,
  });

  final Color backgroundColor;
  final EdgeInsets padding;
  final double size;
  final String data;

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String _data;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo QR CODE'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double w = MediaQuery.of(context).size.width;
                return Hero(
                  tag: 'button_current_day',
                  child: SizedBox(
                    width: w,
                    height: w,
                    child: Padding(
                        padding: widget.padding,
                        child: QrImage(
                          data: _data,
                          version: QrVersions.auto,
                          size: 200.0,
                        )),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.green),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Trống';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          setState(() {
                            _data = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Nhập nội dung cần tạo',
                            labelText: 'Tạo QR Code',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 32,
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                }
                              },
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Mã hiện tại',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text(_data,
                style: const TextStyle(fontSize: 20, color: Colors.green))
          ],
        ),
      ),
    );
  }
}
