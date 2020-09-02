import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lazy_code/lazy_code.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            AspectRatio(
              aspectRatio: 1,
              child: WidthOfScreen(
                percent: 100,
                child: Padding(
                    padding: widget.padding,
                    child: QrImage(
                      data: _data,
                      version: QrVersions.auto,
                      size: 200,
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.green),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Trống';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _data = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Nhập nội dung cần tạo',
                            labelText: 'Tạo QR Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 32,
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
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
