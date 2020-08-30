import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentsocial/models/entities/db_parseable.dart';
import 'package:studentsocial/models/entities/mark.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/entities/schedule.dart';

import '../../../helpers/logging.dart';

///******************** MyDatabase *****************///

class MyDatabase {
  MyDatabase._();

  static MyDatabase _instance;

  static MyDatabase get instance {
    _instance ??= MyDatabase._();
    return _instance;
  }

  static const String dbName = 'student_social.db';
  Database _db;

  Future<Database> get database async {
    return await openDatabase(join(await getDatabasesPath(), dbName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(Schedule.createQuery);
      await db.execute(Mark.createQuery);
      await db.execute(Profile.createQuery);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute(Schedule.dropQuery);
      await db.execute(Mark.dropQuery);
      await db.execute(Profile.dropQuery);
    });
  }

  Future<int> count(String table) async {
    _db = await database;
    final List<Map<String, dynamic>> result =
        await _db.rawQuery('SELECT COUNT(*) FROM $table');
    logs('result count is $result');
    //TODO: check lai logic count
  }

  Future<int> insert(DBParseable data) async {
    _db = await database;
    return await _db.insert(
      data.tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Profile> getProfileByMSV(String msv) async {
    _db = await database;
    final List<Map<String, dynamic>> maps = await _db
        .query(Profile.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Profile.fromJson(maps[0]);
    }
  }

  Future<List<Profile>> getAllProfile([String msv]) async {
    _db = await database;
    final List<Map<String, dynamic>> maps = msv == null
        ? await _db.query(Profile.table)
        : await _db
            .query(Profile.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
    return List.generate(maps.length, (int i) {
      return Profile.fromJson(maps[i]);
    });
  }

  Future<List<Schedule>> getAllScheduleFromDate(
      [String msv, String date]) async {
    _db = await database;
    final maps = msv == null
        ? await _db.query(Schedule.table)
        : await _db.query(Schedule.table,
            where: 'MaSinhVien = ? and Ngay == ?', whereArgs: [msv, date]);
    return List.generate(maps.length, (int i) {
      return Schedule.fromJson(maps[i]);
    });
  }

  Future<List<Schedule>> getAllSchedule([String msv]) async {
    _db = await database;
    final List<Map<String, dynamic>> maps = msv == null
        ? await _db.query(Schedule.table)
        : await _db
            .query(Schedule.table, where: 'MaSinhVien = ?', whereArgs: [msv]);

    logs('map schedule is $maps');

    return List.generate(maps.length, (i) {
      return Schedule.fromJson(maps[i]);
    });
  }

  Future<List<Mark>> getAllMark([String msv]) async {
    _db = await database;
    final List<Map<String, dynamic>> maps = msv == null
        ? await _db.query(Mark.table)
        : await _db
            .query(Mark.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
    return List.generate(maps.length, (i) {
      return Mark.fromJson(maps[i]);
    });
  }

  Future<void> deleteProfile(String msv) async {
    _db = await database;
    await _db.delete(
      Profile.table,
      where: 'MaSinhVien = ?',
      whereArgs: [msv],
    );
    // sau khi xoa profile roi thi xoa het lich va mark cua profile do
    await _db.delete(Schedule.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
    await _db.delete(Mark.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
  }

  Future<int> deleteSchedule(String msv) async {
    _db = await database;
    return await _db
        .delete(Schedule.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
  }

  Future<int> deleteScheduleWithoutNote(String msv) async {
    _db = await database;
    return await _db.delete(Schedule.table,
        where: 'MaSinhVien = ? and LoaiLich != Note', whereArgs: [msv]);
  }

  Future<int> deleteMark(String msv) async {
    _db = await database;
    return await _db
        .delete(Mark.table, where: 'MaSinhVien = ?', whereArgs: [msv]);
  }

  Future<int> deleteAll(String table) async {
    _db = await database;
    return await _db.delete(table);
  }

  Future<int> updateProfile(Profile user) async {
    _db = await database;
    return await _db.update(
      Profile.table,
      user.toJson(),
      where: 'MaSinhVien = ?',
      whereArgs: [user.MaSinhVien],
    );
  }

  Future<int> updateSchedule(Schedule schedule) async {
    _db = await database;
    return await _db.update(
      Schedule.table,
      schedule.toJson(),
      where: 'ID = ?',
      whereArgs: [schedule.MaSinhVien],
    );
  }

  Future<void> updateMark(Mark mark) async {
    _db = await database;
    await _db.update(
      Mark.table,
      mark.toJson(),
      where: 'ID = ?',
      whereArgs: [mark.ID],
    );
  }
}
