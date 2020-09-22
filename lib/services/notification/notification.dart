// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../helpers/date.dart';
import '../../helpers/logging.dart';
import '../../models/entities/schedule.dart';

final _ddmmyyy = DateFormat('dd/MM/yyyy');

class NotificationConfig {
  NotificationConfig() {
    _initNotification();
    //TODO('nhảy đến đúng ngày khi bấm vào notifi')
  }

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//  var initializationSettingsIOS = IOSInitializationSettings(
//      onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings _initializationSettingsIOS =
      const IOSInitializationSettings();
  InitializationSettings _initializationSettings;
  DateSupport _dateSupport;

  String _msv;

  void _initNotification() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializationSettings = InitializationSettings(
        initializationSettingsAndroid, _initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onSelectNotification: _onSelectNotification);
    _dateSupport = DateSupport();
  }

  /// init schedules notification and set notification at 19h30 daily
  Future<void> initSchedulesNotification(
      Map<String, List<Schedule>> entriesOfDay, String msv) async {
    _msv = msv;
    // ban đầu sẽ hủy toàn bộ notifi đã lên lịch từ trước để lên lịch lại từ đầu. đảm bảo các notifi sẽ luôn đc cập nhật chính xác trong mỗi lần mở app hay có thay đổi lịch.
    await _cancelAllNotifi();
    DateTime scheduledNotificationDateTime, dateTimeForGetData;
    List<Schedule> entries;
    //nếu mở app vào lúc > 19:30 thì sẽ không thông báo ngày hôm nay nữa
    var i = 0;
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
      final keyEntries = _ddmmyyy.format(dateTimeForGetData);
      logs('keyEntries is $keyEntries');
      entries = entriesOfDay[keyEntries];
//      print(entries);
      await _scheduleOneNotifi(
          scheduledNotificationDateTime, dateTimeForGetData, i, entries);
    }
    logs('set schedule notification done !');
  }

  Future<void> _cancelAllNotifi() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _scheduleOneNotifi(DateTime scheduledNotificationDateTime,
      DateTime dateTimeForGetData, int id, List<Schedule> entriesOfDay) async {
    final body = _getBody(entriesOfDay);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'student_notifi_id',
      'student_notifi_name',
      'student_notifi_description',
      importance: Importance.Max,
      priority: Priority.High,
      autoCancel: false,
      styleInformation: BigTextStyleInformation(body),
      icon: '@mipmap/ic_launcher',
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.schedule(
        id,
        _getTitle(dateTimeForGetData, entriesOfDay),
        body,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> _onSelectNotification(String payload) async {
    if (payload != null) {
      logs('notification payload: $payload');
    }
//    await Navigator.push(
//      context,
//      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
//    );
  }

  String _getTitle(DateTime dateTimeForGetData, List<Schedule> entriesOfDay) {
    if (entriesOfDay == null || entriesOfDay.isEmpty) {
      return 'Lịch cá nhân ngày ${dateTimeForGetData.day}-${dateTimeForGetData.month}-${dateTimeForGetData.year}';
    } else {
      return '${entriesOfDay.length} Lịch cá nhân ngày ${dateTimeForGetData.day}-${dateTimeForGetData.month}-${dateTimeForGetData.year}';
    }
  }

  String _getBody(List<Schedule> entriesOfDay) {
    if (entriesOfDay == null || entriesOfDay.isEmpty) {
      return 'Ngày mai bạn rảnh ^_^';
    }
    final msg = StringBuffer();
    for (var i = 0; i < entriesOfDay.length; i++) {
      msg.write(_getContentByEntri(entriesOfDay[i]));
      if (i != entriesOfDay.length - 1) {
        msg.write('\n•\n');
      }
    }
    return msg.toString();
  }

  String _getContentByEntri(Schedule entri) {
    if (entri.LoaiLich == 'LichHoc') {
      return 'Môn học: ${entri.HocPhan}\nThời gian: ${entri.TietHoc} ${_dateSupport.getThoiGian(entri.TietHoc, _msv)}\nĐịa điểm: ${entri.DiaDiem}\nGiảng viên: ${entri.GiaoVien}';
    } else if (entri.LoaiLich == 'LichThi') {
      return 'Môn thi: ${entri.HocPhan}\nSố báo danh: ${entri.SoBaoDanh}\nThời gian: ${entri.TietHoc}\nĐịa điểm: ${entri.DiaDiem}\nHình thức: ${entri.HinhThuc}';
    } else if (entri.LoaiLich == 'Note') {
      return 'Tiêu đề: ${entri.MaMon}\nNội dung: ${entri.ThoiGian}';
    }
    return 'unknown';
  }
}
