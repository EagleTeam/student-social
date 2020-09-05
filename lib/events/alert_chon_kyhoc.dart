import 'package:action_mixin/action_mixin.dart';
import 'package:studentsocial/models/entities/semester.dart';

class EventAlertChonKyHoc extends EventBase {
  const EventAlertChonKyHoc({this.semesterResult});

  final SemesterResult semesterResult;
}
