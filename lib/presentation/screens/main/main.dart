import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:provider/provider.dart';
import 'package:studentsocial/helpers/logging.dart';
import 'package:studentsocial/models/entities/event.dart';
import 'package:studentsocial/models/entities/login_result.dart';
import 'package:studentsocial/models/entities/schedule.dart';

import '../../../helpers/dialog_support.dart';
import '../../common_widgets/add_note.dart';
import '../../common_widgets/calendar.dart';
import '../../common_widgets/update_lich.dart';
import 'drawer.dart';
import 'main_notifier.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with DialogSupport {
  MainNotifier _mainNotifier;
  bool listened = false;

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
      body: Selector<MainNotifier, List<Schedule>>(
        selector: (_, mainNotifier) => mainNotifier.getSchedules,
        builder: (_, schedules, __) {
          if (schedules == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return CalendarWidget(
            schedules: schedules,
          );
        },
      ),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogAddGhiChu();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget get _uploadScheduleButton {
    return Selector<MainNotifier, bool>(
      selector: (_, mainNotifier) => mainNotifier.isGuest,
      builder: (_, isGuest, __) {
        if (isGuest) {
          return const SizedBox();
        } else {
          return IconButton(
              onPressed: uploadScheduleClicked,
              icon: const Icon(Icons.cloud_upload));
        }
      },
    );
  }

  void _initViewModel() {
    _mainNotifier = context.read<MainNotifier>();
    _mainNotifier.initSize(MediaQuery.of(context).size);
    if (!listened) {
      _mainNotifier.getStreamAction.listen((data) {
        if (data.type == EventType.alertMessage) {
          showAlertMessage(context, data.data);
          setState(() {});
        } else if (data.type == EventType.alertUpdateSchedule) {
          _showDialogUpdateLich();
        } else if (data.type == EventType.pop) {
          context.pop();
        }
      });
      listened = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initViewModel();
  }

  Future<void> uploadScheduleClicked() async {
    final loginResult = await _mainNotifier.googleLogin();
    logs(loginResult.firebaseUser.photoUrl);
    showGoogleInfo(loginResult);
  }

  void showUploadProcessing() async {
    final events = await _mainNotifier.getEventStudentSocials();
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
                  stream: _mainNotifier.calendarServiceCommunicate
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
                          _mainNotifier.googleLogout();
                          Navigator.of(ct).pop();
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
    return Selector<MainNotifier, bool>(
      selector: (_, mainNotifier) => mainNotifier.isGuest,
      builder: (_, isGuest, __) {
        if (isGuest) {
          return const SizedBox();
        } else {
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
        }
      },
    );
  }

  Future<void> _showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddNote(
          date: _mainNotifier.getClickedDay,
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
