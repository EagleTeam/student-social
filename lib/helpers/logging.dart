// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:logger/logger.dart';

final Logger logger = Logger(printer: PrettyPrinter(methodCount: 5));

void logs(dynamic message) {
  if (kDebugMode) {
    logger.d(message);
  }
}
