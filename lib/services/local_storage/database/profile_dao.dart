import 'package:studentsocial/models/entities/profile.dart';

import 'database.dart';

class ProfileDao {
  ProfileDao(this.database);
  final MyDatabase database;

  Future<int> insertOnlyUser(Profile user) async {
    return database.insert(user);
  }

  Future<int> updateOnlyUser(Profile user) async {
    return database.updateProfile(user);
  }

  Future<void> deleteOnlyUser(Profile user) async {
    await database.deleteProfile(user.MaSinhVien);
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
