import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main.dart';
import '../../../../models/entities/profile.dart';
import '../database.dart';

/// provider profileRepository by watch databaseProvider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(databaseProvider));
});

class ProfileRepository {
  ProfileRepository(this.database);

  final MyDatabase database;

  Future<int> insertOnlyUser(Profile user) async {
    return database.insert(user);
  }

  Future<int> updateOnlyUser(Profile user) async {
    return database.updateProfile(user);
  }

  Future<void> deleteOnlyUser(Profile user) async {
    return database.deleteProfile(user.MaSinhVien);
  }

  Future<Profile> getUserByMSV(String msv) async {
    return database.getProfileByMSV(msv);
  }

  Future<int> deleteAllUser() async {
    return database.deleteAll(Profile.table);
  }

  Future<void> deleteUserByMSV(String msv) async {
    return database.deleteProfile(msv);
  }

  Future<List<Profile>> getAllUsers() {
    return database.getAllProfile();
  }
}
