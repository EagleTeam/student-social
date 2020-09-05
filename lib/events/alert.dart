import 'package:action_mixin/action_mixin.dart';

class EventAlert extends EventBase {
  const EventAlert({this.message});

  final String message;
}
