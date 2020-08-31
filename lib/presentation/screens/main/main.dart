import 'dart:async';

import 'package:action_mixin/action_mixin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:studentsocial/presentation/screens/extracurricular/extracurricular.dart';
import 'package:studentsocial/presentation/screens/login/login.dart';
import 'package:studentsocial/presentation/screens/mark/mark.dart';
import 'package:studentsocial/presentation/screens/qr/qrcode_view.dart';

import '../../../events/alert.dart';
import '../../../events/alert_update_schedule.dart';
import '../../../events/pop.dart';
import '../../../helpers/dialog_support.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login_result.dart';
import '../../common_widgets/add_note.dart';
import '../../common_widgets/calendar.dart';
import '../../common_widgets/circle_loading.dart';
import '../../common_widgets/update_lich.dart';
import '../settings.dart';
import '../time_table.dart';
import 'drawer.dart';
import 'main_notifier.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _initActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Social'),
        actions: <Widget>[
          _uploadScheduleButton,
          _updateScheduleButton,
        ],
      ),
      body: Consumer(
        builder: (ctx, watch, child) {
          final schedules = watch(mainProvider).getSchedules;
          if (schedules == null) {
            return const CircleLoading();
          }
          return CalendarWidget(
            schedules: schedules,
          );
        },
      ),
      drawer: DrawerWidget(
          loginTap: loginTap,
          timeTableTap: timeTableTap,
          markTap: markTap,
          extracurricularTap: extracurricularTap,
          qrCodeTap: qrCodeTap,
          supportTap: supportTap,
          settingTap: settingTap),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogAddGhiChu();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // action for tile

  Future<void> loginTap() async {
    await context.push((BuildContext context) => LoginScreen());
    context.read(mainProvider).loadCurrentMSV();
    context.refresh(mainProvider);
  }

  Future<void> timeTableTap() async {
    context.push((_) => TimeTable(msv: context.read(mainProvider).getMSV));
  }

  void markTap() {
    context.push((_) => MarkScreen());
  }

  void extracurricularTap() {
    context.push(
      (_) => ExtracurricularScreen(
        msv: context.read(mainProvider).getMSV,
      ),
    );
  }

  void qrCodeTap() {
    context.push((BuildContext context) => QRCodeScreen(
          data: context.read(mainProvider).getMSV,
        ));
  }

  void supportTap() {
    context.read(mainProvider).launchURL();
  }

  void settingTap() {
    context.push(((_) => SettingScren()));
  }

  void logoutTap() {
    _confirmLogout();
  }

  // done

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
                context.pop();
              },
              child: const Text(
                'Huỷ',
                style: TextStyle(color: Colors.red),
              ),
            ),
            FlatButton(
              onPressed: () {
                context.pop();
                context.read(mainProvider).logOut();
              },
              child: const Text('Đồng ý'),
            )
          ],
        );
      },
    );
  }

  Widget get _uploadScheduleButton {
    return Consumer(
        builder: (ctx, watch, child) {
          final bool isGuest = watch(mainProvider).isGuest;
          if (isGuest) {
            return const SizedBox();
          }
          return child;
        },
        child: IconButton(
            onPressed: uploadScheduleClicked,
            icon: const Icon(Icons.cloud_upload)));
  }

  List<ActionEntry> actions() {
    return [
      ActionEntry(event: const EventPop(), action: (_) => pop(context)),
      ActionEntry(
          event: const EventAlertUpdateSchedule(),
          action: (_) => _showDialogUpdateLich()),
      ActionEntry(
          event: const EventAlert(),
          action: (event) {
            if (event is EventAlert) {
              showAlertMessage(context, event.message);
              setState(() {});
            }
          }),
    ];
  }

  void _initActions() {
    context.read(mainProvider).initActions(actions());
  }

  Future<void> uploadScheduleClicked() async {
    final loginResult = await context.read(mainProvider).googleLogin();
    logs(loginResult.firebaseUser.photoUrl);
    showGoogleInfo(loginResult);
  }

  void showUploadProcessing() async {
    final events = await context.read(mainProvider).getEventStudentSocials();
    showDialog(
        context: context,
        barrierDismissible: false, // Khong duoc an dialog
        builder: (ct) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder(
                  stream: context
                      .read(mainProvider)
                      .calendarServiceCommunicate
                      .addEvents(events),
                  builder: (context, snapshot) {
                    logs('data is ${snapshot.data}');
                    if (snapshot.hasData) {
                      if (snapshot.data < 1.0) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: CircularProgressIndicator(
                              value: snapshot.data,
                            )),
                            Text(
                                'Đang tải lên ${((snapshot.data as double) * 100).toInt()}%')
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 50,
                            )),
                            const Text('Tải lên hoàn tất!'),
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(ct).pop();
                              },
                              child: const Text('Xong'),
                            )
                          ],
                        );
                      }
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                  }),
            ),
          );
        });
  }

  void showGoogleInfo(LoginResult loginResult) {
    showDialog(
        context: context,
        builder: (ct) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.2),
                    child: CachedNetworkImage(
                      imageUrl: loginResult.firebaseUser.photoUrl,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      placeholder: (_, __) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        loginResult.firebaseUser.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () async {
                          context.read(mainProvider).googleLogout();
                          pop(ct);
                          uploadScheduleClicked();
                        },
                        icon: const Icon(Icons.refresh),
                      )
                    ],
                  ),
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(ct).pop();
                      showUploadProcessing();
                    },
                    child: const Text('Tải lên Google Calendar'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget get _updateScheduleButton {
    return Consumer(
      builder: (ctx, watch, child) {
        final isGuest = watch(mainProvider).isGuest;
        if (isGuest) {
          return const SizedBox();
        }
        return IconButton(
          icon: const Icon(Icons.refresh),
//            onPressed: _mainNotifier.updateSchedule,
          onPressed: () {
            showDialog(
                context: context,
                builder: (ct) {
                  return AlertDialog(
                    title: const Text(':('),
                    content: const Text('Tính năng đang được bảo trì'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ct).pop();
                        },
                        child: const Text('ok'),
                      )
                    ],
                  );
                });
          },
        );
      },
    );
  }

  Future<void> _showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddNote(
          // date: context.read(mainProvider).getClickedDay,
          context: this.context,
        ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bao vao update lich
   */

  Future<void> _showDialogUpdateLich() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UpdateLich(
          mcontext: this.context,
        ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bam vao them ghi chu
   */

  Future<void> showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddNote(
//          date: _mainViewModel.getDate,
            ); //magic ^_^
      },
    );
  }
}
