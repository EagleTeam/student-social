// Flutter imports:
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt ứng dụng'),
      ),
      body: const Center(
        child: Text('Đang trong quá trình xây dựng'),
      ),
    );
  }
}
