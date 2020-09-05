import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_code/lazy_code.dart';

import '../../../models/entities/profile.dart';
import '../login/login.dart';
import 'main_notifier.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget(
      {this.loginTap,
      this.timeTableTap,
      this.markTap,
      this.extracurricularTap,
      this.qrCodeTap,
      this.supportTap,
      this.settingTap,
      this.logoutTap});

  final VoidCallback loginTap;
  final VoidCallback timeTableTap;
  final VoidCallback markTap;
  final VoidCallback extracurricularTap;
  final VoidCallback qrCodeTap;
  final VoidCallback supportTap;
  final VoidCallback settingTap;
  final VoidCallback logoutTap;

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Widget _loginTile() {
    return _Tile(
      title: 'Đăng nhập bằng tài khoản sinh viên',
      icon: Icons.account_circle,
      onTap: widget.loginTap,
    );
  }

  Widget _timeTableTile() {
    return _Tile(
      title: 'Thời gian ra vào lớp',
      icon: Icons.access_time,
      onTap: widget.timeTableTap,
    );
  }

  Widget _markTile() {
    return _Tile(
      title: 'Tra cứu điểm',
      icon: Icons.assessment,
      onTap: widget.markTap,
    );
  }

  Widget _extracurricularTile() {
    return _Tile(
      title: 'Tra cứu điểm ngoại khóa',
      icon: Icons.assistant_photo,
      onTap: widget.extracurricularTap,
    );
  }

  Widget _QRCodeTile() {
    return _Tile(
      title: 'Tạo QR CODE',
      icon: Icons.blur_on,
      onTap: widget.qrCodeTap,
    );
  }

  Widget _supportTile() {
    return _Tile(
      title: 'Phản ánh lỗi, góp ý',
      icon: Icons.error,
      onTap: widget.supportTap,
    );
  }

  Widget _settingTile() {
    return _Tile(
      title: 'Cài đặt ứng dụng',
      icon: Icons.settings,
      onTap: widget.settingTap,
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
        context.pop();
        widget.logoutTap();
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
                    child: Text(context
                        .read(mainProvider)
                        .getName
                        .substring(0, 1)
                        .toUpperCase()),
                  ),
                  title: Text(
                    context.read(mainProvider).getName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(context.read(mainProvider).getClass),
                ),
                const Divider(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                      itemCount:
                          context.read(mainProvider).getAllProfile.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _layoutItemAccount(index);
                      }),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () async {
                    context..pop()..pop();
                    await context.push((_) => LoginScreen());
                    context.read(mainProvider).loadCurrentMSV();
                    context.refresh(mainProvider);
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
    final Profile profile = context.read(mainProvider).getAllProfile[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(profile?.HoTen?.substring(0, 1)?.toUpperCase()),
      ),
      title: Text(
        profile.HoTen ?? 'Họ Tên',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(profile.Lop ?? 'Lớp trống',
          style: const TextStyle(fontSize: 11)),
      onTap: () async {
        context.read(mainProvider).switchToProfile(profile);
        context..pop()..pop();
      },
    );
  }

  Widget _nameOfUser() {
    return Text(
      context.read(mainProvider).getName,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _classOfUser() {
    if (context.read(mainProvider).getClass.isNotEmpty) {
      return Text(
        context.read(mainProvider).getClass,
        style: const TextStyle(color: Colors.white),
      );
    }
    return const SizedBox();
  }

  Widget _getAccountPicture() {
    if (context.read(mainProvider).isGuest) {
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
          context.read(mainProvider).getAvatarName,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Widget> listItemDrawer() {
    if (context.read(mainProvider).isGuest) {
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
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: listItemDrawer()),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    this.title,
    this.icon,
    this.colorIcon = Colors.green,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color colorIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        icon,
        size: 30,
        color: colorIcon,
      ),
      onTap: () {
        context.pop();
        onTap?.call();
      },
    );
  }
}
