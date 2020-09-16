import 'dart:async';

import 'package:action_mixin/action_mixin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:studentsocial/services/local_storage/shared_prefs.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../events/alert.dart';
import '../../../events/alert_chon_kyhoc.dart';
import '../../../events/alert_update_schedule.dart';
import '../../../events/loading_message.dart';
import '../../../events/pop.dart';
import '../../../events/save_success.dart';
import '../../../helpers/dialog_support.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login_result.dart';
import '../../../models/update_schedule.dart';
import '../../common_widgets/add_note.dart';
import '../../common_widgets/calendar.dart';
import '../../common_widgets/circle_loading.dart';
import '../extracurricular/extracurricular.dart';
import '../login/login.dart';
import '../mark/mark.dart';
import '../qr/qrcode_view.dart';
import '../settings.dart';
import '../time_table.dart';
import 'drawer.dart';
import 'main_notifier.dart';
import 'main_providers.dart';

final _currentCalendarViewProvider = FutureProvider<CalendarView>((ref) async {
  final caledarView = await SharedPrefs.instance.getCalendarView();
  ref.read(calendarViewProvider).state = caledarView;
  return caledarView;
});

class MainScreen extends StatefulWidget {
  const MainScreen();

  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  CalendarController _calendarController;
  UpdateSchedule _updateSchedule;

  @override
  void initState() {
    super.initState();
    context.read(mainProvider).initActions(_actions());
    _calendarController = CalendarController();
    _updateSchedule = UpdateSchedule(
      ScheduleType.update,
    );
    _updateSchedule.initActions(_actionUpdate());
  }

  List<ActionEntry> _actions() {
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

  List<ActionEntry> _actionUpdate() {
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
              _updateSchedule.showAlertChonKyHoc(context, event.semesterResult);
            }
          }),
      ActionEntry(
          event: const EventSaveSuccess(),
          action: (event) {
            if (event is EventSaveSuccess) {
              _updateSuccess();
            }
          }),
    ];
  }

  Future<void> _updateSuccess() async {
    await showSuccess(context, 'Cập nhật xong !');
    context.refresh(mainProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Social'),
        actions: <Widget>[
          _uploadScheduleButton,
          _updateScheduleButton,
          _switchCalendarView()
        ],
      ),
      body: Consumer(
        builder: (ctx, watch, child) {
          final schedules = watch(mainProvider).getSchedules;
          final currentCalendarView = watch(_currentCalendarViewProvider);

          if (schedules == null || currentCalendarView.data == null) {
            return const CircleLoading();
          }
          return CalendarWidget(
              schedules: schedules, controller: _calendarController);
        },
      ),
      drawer: DrawerWidget(
        loginTap: _loginTap,
        timeTableTap: _timeTableTap,
        markTap: _markTap,
        extracurricularTap: _extracurricularTap,
        qrCodeTap: _qrCodeTap,
        supportTap: _supportTap,
        settingTap: _settingTap,
        logoutTap: _logoutTap,
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _switchCalendarView() {
    return IconButton(
      onPressed: () async {
        if (context.read(calendarViewProvider).state == CalendarView.month) {
          context.read(calendarViewProvider).state = CalendarView.schedule;
        } else {
          context.read(calendarViewProvider).state = CalendarView.month;
        }
        await SharedPrefs.instance
            .setCalendarView(context.read(calendarViewProvider).state);
      },
      icon: Consumer(
        builder: (ctx, watch, child) {
          final calendarView = watch(calendarViewProvider).state;
          if (calendarView == CalendarView.schedule) {
            return const Icon(Icons.calendar_today);
          }
          return const Icon(Icons.calendar_view_day_outlined);
        },
      ),
    );
  }

  Widget _floatingActionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _calendarController.selectedDate = DateTime.now();
            _calendarController.displayDate = DateTime.now();
          },
          child: Text(
            DateTime.now().day.toString(),
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }

  // **************** action for tile

  Future<void> _loginTap() async {
    await context.push((_) => LoginScreen());
    await context.read(mainProvider).loadCurrentMSV();
    context.refresh(mainProvider);
  }

  Future<void> _timeTableTap() async {
    await context
        .push((_) => TimeTable(msv: context.read(mainProvider).getMSV));
  }

  void _markTap() {
    context.push((_) => MarkScreen());
  }

  void _extracurricularTap() {
    context.push(
      (_) => ExtracurricularScreen(
        msv: context.read(mainProvider).getMSV,
      ),
    );
  }

  void _qrCodeTap() {
    context.push(
      (context) => QRCodeScreen(
        data: context.read(mainProvider).getMSV,
      ),
    );
  }

  void _supportTap() {
    context.read(mainProvider).launchURL();
  }

  void _settingTap() {
    context.push(((_) => SettingScren()));
  }

  void _logoutTap() {
    _confirmLogout();
  }

  // ****************** done

  Future<void> _confirmLogout() async {
    await showDialog(
      context: context,
      builder: (context) {
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
          final isGuest = watch(mainProvider).isGuest;
          if (isGuest) {
            return const SizedBox();
          }
          return child;
        },
        child: IconButton(
            onPressed: _uploadScheduleClicked,
            icon: const Icon(Icons.cloud_upload)));
  }

  Future<void> _uploadScheduleClicked() async {
    final loginResult = await context.read(mainProvider).googleLogin();
    logs(loginResult.user.photoURL);
    _showGoogleInfo(loginResult);
  }

  Future<void> _showUploadProcessing() async {
    final events = await context.read(mainProvider).getEventStudentSocials();
    await showDialog(
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
                        children: const [
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                  }),
            ),
          );
        });
  }

  void _showGoogleInfo(LoginResult loginResult) {
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
                      imageUrl: loginResult.user.photoURL,
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
                        loginResult.user.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () async {
                          await context.read(mainProvider).googleLogout();
                          pop(ct);
                          await _uploadScheduleClicked();
                        },
                        icon: const Icon(Icons.refresh),
                      )
                    ],
                  ),
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(ct).pop();
                      _showUploadProcessing();
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
          onPressed: () async {
            final currentProfile =
                await context.read(currentProfileProvider.future);

            if (currentProfile.Token == null) {
              await showAlertMessage(context,
                  'Hình như bạn đã đăng nhập từ phiên bản trước đó, bạn cần đăng xuất và đăng nhập lại để tính năng có thể hoạt động chính xác !');
              return;
            }
            showLoading(context);
            _updateSchedule.token = currentProfile.Token;
            _updateSchedule.msv = currentProfile.MaSinhVien;
            _updateSchedule.update();
          },
        );
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
      builder: (context) {
        // return UpdateSchedule(
        //   mcontext: this.context,
        // ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bam vao them ghi chu
   */
  Future<void> _showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AddNote(
          // date: context.read(mainProvider).getClickedDay,
          context: this.context,
        ); //magic ^_^
      },
    );
  }
}
