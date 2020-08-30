import 'package:studentsocial/models/entities/profile.dart';

import '../database.dart';
import '../profile_dao.dart';

class ProfileRepository {
  ProfileRepository(MyDatabase database) {
    profileDao = ProfileDao(database);
  }

  ProfileDao profileDao;

  Future<int> insertOnlyUser(Profile user) async {
    return await profileDao.insertOnlyUser(user);
  }

  Future<int> deleteAllUser() async {
    return await profileDao.deleteAllUser();
  }

  Future<void> deleteUserByMSV(String msv) async {
    return profileDao.deleteUserByMSV(msv);
  }

  Future<int> updateOnlyUser(Profile user) async {
    return profileDao.updateOnlyUser(user);
  }

  Future<Profile> getUserByMaSV(String msv) async {
    return await profileDao.getUserByMSV(msv);
  }

  Future<List<Profile>> getAllUsers() async {
    return await profileDao.getAllUsers();
  }
}
