// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/services/local_storage/database/repository/profile_repository.dart';
import 'package:studentsocial/services/local_storage/shared_prefs.dart';

/// provider dateSelected for display schedule in main
final dateSelectedProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

final currentProfileProvider = FutureProvider<Profile>((ref) async {
  final currentMSV = await SharedPrefs.instance.getCurrentMSV();

  return ProfileRepository.instance.getUserByMSV(currentMSV);
});
