import 'schedule.dart';

class EventStudentSocial {
  EventStudentSocial(this.schedule);

  final Schedule schedule;

  Map<String, dynamic> toJson() {
    return {
      'summary': schedule.LoaiLich == 'LichHoc'
          ? schedule.hocPhanClean
          : 'SBD ${schedule.SoBaoDanh}: ${schedule.hocPhanClean} ',
      'location': schedule.diaDiemClean,
      'description':
          schedule.LoaiLich == 'LichHoc' ? schedule.GiaoVien : schedule.TietHoc,
      'start': {
        'dateTime': schedule.startTime.toIso8601String(),
        'timeZone': 'Asia/Ho_Chi_Minh'
      },
      'end': {
        'dateTime': schedule.endTime.toIso8601String(),
        'timeZone': 'Asia/Ho_Chi_Minh'
      },
      'reminders': {
        'useDefault': false,
        'overrides': [
          {'method': 'popup', 'minutes': 30}
        ]
      }
    };
  }
}
