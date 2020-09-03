import 'package:flutter_riverpod/flutter_riverpod.dart';

/// provider dateSelected for display schedule in main
final dateSelectedProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});
