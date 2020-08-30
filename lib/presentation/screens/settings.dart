import 'package:flutter/material.dart';

class SettingScren extends StatefulWidget {
  @override
  _SettingScrenState createState() => _SettingScrenState();
}

class _SettingScrenState extends State<SettingScren> {
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
