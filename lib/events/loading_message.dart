// Package imports:
import 'package:action_mixin/action_mixin.dart';

class EventLoadingMessage extends EventBase {
  const EventLoadingMessage({this.message});

  final String message;
}
