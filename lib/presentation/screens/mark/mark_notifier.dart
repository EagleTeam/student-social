// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:studentsocial/helpers/logging.dart';
import '../../../models/entities/mark.dart';
import '../../../models/entities/profile.dart';
import 'mark_model.dart';

final markProvider = ChangeNotifierProvider<MarkNotifier>((ref) {
  return MarkNotifier();
});

class MarkNotifier with ChangeNotifier {
  MarkNotifier() {
    _markModel = MarkModel();
    loadCurrentMSV();
  }

  MarkModel _markModel;

  String get getMSV => _markModel.msv;

  String get getToken => _markModel.profile.Token;

  List<Mark> getListMark() {
    if (_markModel.filterType == 'ALL') {
      return _markModel.listMark;
    }
    _markModel.listMarkFilter = <Mark>[];
    _markModel.listMarkFilter.addAll(_markModel.listMark);
    _markModel.listMarkFilter
        .removeWhere((Mark mark) => mark.DiemChu != _markModel.filterType);
    return _markModel.listMarkFilter;
  }

  String get getTongTC => _markModel.profile.TongTC;

  String get getSTCTD => _markModel.profile.STCTD;

  String get getDTBC => _markModel.profile.DTBC;

  String get getDTBCQD => _markModel.profile.DTBCQD;

  String get getSTCTLN => _markModel.profile.STCTLN;

  String get getSoMonKhongDat => _markModel.profile.SoMonKhongDat;

  String get getSoTCKhongDat => _markModel.profile.SoTCKhongDat;

  Future<void> loadCurrentMSV() async {
//    String value = await PlatformChannel.database
//        .invokeMethod(PlatformChannel.getCurrentMSV);
//    _markModel.msv = value;
//    if (value.isNotEmpty) {
//      loadProfile();
//      loadMarks();
//    }
  }

  Future<void> loadProfile() async {
    try {
//      String value = await PlatformChannel.database.invokeMethod(
//          PlatformChannel.getProfile,
//          <String, String>{'msv': _markModel.msv});
//      _markModel.profileValue = value;
//      _initProfile(value);
      notifyListeners();
    } catch (e) {
      //TODO()
    }
  }

  Future<void> loadMarks() async {
    try {
//      String value = await PlatformChannel.database.invokeMethod(
//          PlatformChannel.getMark,
//          <String, String>{'msv': _markModel.msv});
//      _markModel.markValue = value;
//      _initMarks(value);
      notifyListeners();
    } catch (e) {
      //TODO()
    }
  }

  void _initMarks(String value) {
    if (value.isNotEmpty) {
      _markModel.listMark = <Mark>[];
      final jsonData = json.decode(value);
      for (var item in jsonData) {
        _markModel.listMark.add(Mark.fromJson(item));
      }
    } else {
      //TODO()
    }
  }

  void _initProfile(String value) {
    if (value.isNotEmpty) {
      final jsonData = json.decode(value);
      _markModel.profile = Profile.fromJson(jsonData);
      _markModel.profile.setMoreDetailByJson(jsonData);
    } else {
      logs('value profile is empty');
    }
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
//    if (result == ConnectivityResult.none) {
//      alert('Không có kết nối mạng :(');
//    } else if (result == ConnectivityResult.mobile) {
//      showDialogUpdateDiem();
//      getDiem();
//    } else if (result == ConnectivityResult.wifi) {
//      showDialogUpdateDiem();
//      getDiem();
//    }
  }

  void actionFilter(String type) {
    _markModel.filterType = type;
    notifyListeners();
  }
}
