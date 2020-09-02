import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../helpers/date.dart';
import '../../helpers/logging.dart';
import '../../models/entities/schedule.dart';

class NotificationConfig {
  NotificationConfig() {
    init();
    //TODO('nhảy đến đúng ngày khi bấm vào notifi')
  }

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//  var initializationSettingsIOS = IOSInitializationSettings(
//      onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  IOSInitializationSettings initializationSettingsIOS =
      const IOSInitializationSettings();
  InitializationSettings initializationSettings;
  DateSupport _dateSupport;

  String msv;

  void init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _dateSupport = DateSupport();
  }

  Future<void> initSchedulesNotification(
      Map<String, List<Schedule>> entriesOfDay, String msv) async {
    this.msv = msv;
    // ban đầu sẽ hủy toàn bộ notifi đã lên lịch từ trước để lên lịch lại từ đầu. đảm bảo các notifi sẽ luôn đc cập nhật chính xác trong mỗi lần mở app hay có thay đổi lịch.
    await cancelAllNotifi();
    DateTime scheduledNotificationDateTime, dateTimeForGetData;
    List<Schedule> entries;
    //nếu mở app vào lúc > 19:30 thì sẽ không thông báo ngày hôm nay nữa
    int i = 0;
    if (_dateSupport.getHour() >= 19) {
      if (_dateSupport.getHour() == 19) {
        if (_dateSupport.getMinute() >= 30) {
          i = 1;
        }
      } else {
        i = 1;
      }
    }
    for (; i < 14; i++) {
      //thông báo liên tiếp 2 tuần tiếp theo
      scheduledNotificationDateTime = _dateSupport.getDate(i);
      dateTimeForGetData = _dateSupport.getDate(i +
          1); // ví dụ ngày hôm nay thì phải lấy lịch của ngày hôm sau để thông báo
//      print(_dateSupport.format(scheduledNotificationDateTime));
      entries = entriesOfDay[_dateSupport.format(dateTimeForGetData)];
//      print(entries);
      await scheduleOneNotifi(
          scheduledNotificationDateTime, dateTimeForGetData, i, entries);
    }
    logs('set schedule notification done !');
  }

  Future<void> cancelAllNotifi() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleOneNotifi(DateTime scheduledNotificationDateTime,
      DateTime dateTimeForGetData, int id, List<Schedule> entriesOfDay) async {
    final String body = getBody(entriesOfDay);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'student_notifi_id',
      'student_notifi_name',
      'student_notifi_description',
      importance: Importance.Max,
      priority: Priority.High,
      autoCancel: false,
      styleInformation: BigTextStyleInformation(body),
      icon: '@mipmap/ic_launcher',
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        id,
        getTitle(dateTimeForGetData, entriesOfDay),
        body,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      logs('notification payload: $payload');
    }
//    await Navigator.push(
//      context,
//      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
//    );
  }

  String getTitle(DateTime dateTimeForGetData, List<Schedule> entriesOfDay) {
    if (entriesOfDay == null || entriesOfDay.isEmpty) {
      return 'Lịch cá nhân ngày ${dateTimeForGetData.day}-${dateTimeForGetData.month}-${dateTimeForGetData.year}';
    } else {
      return '${entriesOfDay.length} Lịch cá nhân ngày ${dateTimeForGetData.day}-${dateTimeForGetData.month}-${dateTimeForGetData.year}';
    }
  }

  String getBody(List<Schedule> entriesOfDay) {
    if (entriesOfDay == null || entriesOfDay.isEmpty) {
      return 'Ngày mai bạn rảnh ^_^';
    }
    String msg = '';
    for (int i = 0; i < entriesOfDay.length; i++) {
      msg += getContentByEntri(entriesOfDay[i]);
      if (i != entriesOfDay.length - 1) {
        msg += '\n•\n';
      }
    }
    return msg;
  }

  String getContentByEntri(Schedule entri) {
    if (entri.LoaiLich == 'LichHoc') {
      return 'Môn học: ${entri.HocPhan}\nThời gian: ${entri.TietHoc} ${_dateSupport.getThoiGian(entri.TietHoc, msv)}\nĐịa điểm: ${entri.DiaDiem}\nGiảng viên: ${entri.GiaoVien}';
    } else if (entri.LoaiLich == 'LichThi') {
      return 'Môn thi: ${entri.HocPhan}\nSố báo danh: ${entri.SoBaoDanh}\nThời gian: ${entri.TietHoc}\nĐịa điểm: ${entri.DiaDiem}\nHình thức: ${entri.HinhThuc}';
    } else if (entri.LoaiLich == 'Note') {
      return 'Tiêu đề: ${entri.MaMon}\nNội dung: ${entri.ThoiGian}';
    }
    return 'unknown';
  }
}
