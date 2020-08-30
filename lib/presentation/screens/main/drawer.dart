import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:provider/provider.dart';
import 'package:studentsocial/services/local_storage/database/database.dart';

import '../../../models/entities/profile.dart';
import '../extracurricular/extracurricular.dart';
import '../login/login.dart';
import '../login/login_notifier.dart';
import '../mark/mark.dart';
import '../mark/mark_notifier.dart';
import '../qr/qrcode_view.dart';
import '../settings.dart';
import '../time_table.dart';
import 'main_notifier.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  MainNotifier _mainNotifier;

  Widget _loginTile() {
    return ListTile(
      title: const Text('Đăng nhập bằng tài khoản sinh viên'),
      leading: const Icon(
        Icons.account_circle,
        size: 30,
        color: Colors.green,
      ),
      onTap: () async {
        context.pop();
        await context.push((BuildContext context) =>
            ChangeNotifierProvider<LoginNotifier>(
              create: (_) => LoginNotifier(Provider.of<MyDatabase>(context)),
              child: LoginScreen(),
            ));
        _mainNotifier.loadCurrentMSV();
      },
    );
  }

  Widget _timeTableTile() {
    return ListTile(
      title: const Text('Thời gian ra vào lớp'),
      leading: const Icon(
        Icons.access_time,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context
          ..pop()
          ..push((_) => TimeTable(msv: _mainNotifier.getMSV));
      },
    );
  }

  Widget _markTile() {
    return ListTile(
      title: const Text('Tra cứu điểm'),
      leading: const Icon(
        Icons.assessment,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<MarkNotifier>(
                  create: (_) => MarkNotifier(),
                  child: MarkScreen(),
                )));
      },
    );
  }

  Widget _extracurricularTile() {
    return ListTile(
      title: const Text('Tra cứu điểm ngoại khóa'),
      leading: const Icon(
        Icons.assistant_photo,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context
          ..pop()
          ..push(
            (_) => ExtracurricularScreen(
              msv: _mainNotifier.getMSV,
            ),
          );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _QRCodeTile() {
    return ListTile(
      title: const Text('Tạo QR CODE'),
      leading: const Icon(
        Icons.blur_on,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => QRCodeScreen(
                data: _mainNotifier.getMSV,
              ),
            ));
      },
    );
  }

  Widget _supportTile() {
    return ListTile(
      title: const Text('Phản ánh lỗi, góp ý'),
      leading: const Icon(
        Icons.error,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context.pop();
        _mainNotifier.launchURL();
      },
    );
  }

  Widget _settingTile() {
    return ListTile(
      title: const Text('Cài đặt ứng dụng'),
      leading: const Icon(
        Icons.settings,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context
          ..pop()
          ..push(((_) => SettingScren()));
      },
    );
  }

  Widget _logoutTile() {
    return ListTile(
      title: const Text('Đăng xuất'),
      leading: const RotatedBox(
        quarterTurns: 2,
        child: Icon(
          Icons.exit_to_app,
          size: 30,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        _confirmLogout();
      },
    );
  }

  Future<void> _confirmLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bạn có muốn đăng xuất không?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Huỷ',
                style: TextStyle(color: Colors.red),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mainNotifier.logOut();
              },
              child: const Text('Đồng ý'),
            )
          ],
        );
      },
    );
  }

  Widget _drawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(color: Colors.green),
      child: UserAccountsDrawerHeader(
          currentAccountPicture: _getAccountPicture(),
          otherAccountsPictures: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                _showAccountSetting();
              },
            ),
          ],
          accountName: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _nameOfUser(),
          ),
          accountEmail: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _classOfUser(),
          )),
    );
  }

  void _showAccountSetting() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(6),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    child: Text(
                        _mainNotifier.getName.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(
                    _mainNotifier.getName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_mainNotifier.getClass),
                ),
                const Divider(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                      itemCount: _mainNotifier.getAllProfile.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _layoutItemAccount(index);
                      }),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () async {
                    context..pop()..pop();
                    await context.push((_) =>
                        ChangeNotifierProvider<LoginNotifier>(
                          create: (_) =>
                              LoginNotifier(Provider.of<MyDatabase>(context)),
                          child: LoginScreen(),
                        ));
                    _mainNotifier.loadCurrentMSV();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                    child: Row(
                      children: const <Widget>[
                        Icon(
                          Icons.person_add,
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          // ignore: prefer_const_literals_to_create_immutables
                          child: Text(
                            'Thêm một tài khoản khác',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _layoutItemAccount(int index) {
    final Profile profile = _mainNotifier.getAllProfile[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _mainNotifier.getRandomColor(),
        child: Text(profile?.HoTen?.substring(0, 1)?.toUpperCase()),
      ),
      title: Text(
        profile.HoTen ?? 'Họ Tên',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(profile.Lop ?? 'Lớp trống',
          style: const TextStyle(fontSize: 11)),
      onTap: () async {
        _mainNotifier.switchToProfile(profile);
        context..pop()..pop();
      },
    );
  }

  Widget _nameOfUser() {
    if (_mainNotifier.getMSV == 'DTC165D4801030254') {
      return const Text(
        'TUyenOC',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Text(
        _mainNotifier.getName,
        style: const TextStyle(color: Colors.white),
      );
    }
  }

  Widget _classOfUser() {
    if (_mainNotifier.getMSV == 'DTC165D4801030254') {
      return const Text(
        'Tài khoản Premium',
        style: TextStyle(color: Colors.white),
      );
    } else {
      if (_mainNotifier.getClass.isNotEmpty) {
        return Text(
          _mainNotifier.getClass,
          style: const TextStyle(color: Colors.white),
        );
      } else {
        return const SizedBox();
      }
    }
  }

  Widget _getAccountPicture() {
    if (_mainNotifier.isGuest) {
      // logo for guest
      return Container(
        width: 80,
        height: 80,
        child: const CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: AssetImage('image/Logo.png'),
        ),
      );
    }

    return Container(
      width: 80,
      height: 80,
      child: CircleAvatar(
        backgroundColor: Colors.yellow,
        child: Text(
          _mainNotifier.getAvatarName,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Widget> listItemDrawer() {
    if (_mainNotifier.isGuest) {
      //những menu này dành cho người chưa đăng nhập
      return [
        _drawerHeader(),
        _loginTile(),
        _timeTableTile(),
        _QRCodeTile(),
        _supportTile(),
        const Divider(),
        _settingTile()
      ];
    } else {
      //menu dành cho người dùng đã đăng nhập
      return [
        _drawerHeader(),
        _timeTableTile(),
        _markTile(),
        _extracurricularTile(), //Điểm ngoại khóa
        _QRCodeTile(),
        _supportTile(),
        _logoutTile(),
        const Divider(),
        _settingTile()
      ];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainNotifier = context.read<MainNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: listItemDrawer()),
    );
  }
}
