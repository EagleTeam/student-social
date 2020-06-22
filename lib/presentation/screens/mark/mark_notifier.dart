import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/models/entities/mark.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/presentation/screens/mark/mark_model.dart';

class MarkNotifier with ChangeNotifier {
  MarkModel _markModel;

  MarkNotifier() {
    _markModel = MarkModel();
    loadCurrentMSV();
  }

  String get getMSV => _markModel.msv;

  String get getToken => _markModel.profile.Token;

  List<Mark> getListMark() {
    if (_markModel.filterType == 'ALL') {
      return _markModel.listMark;
    }
    _markModel.listMarkFilter = List<Mark>();
    _markModel.listMarkFilter.addAll(_markModel.listMark);
    _markModel.listMarkFilter
        .removeWhere((mark) => mark.DiemChu != _markModel.filterType);
    return _markModel.listMarkFilter;
  }

  get getTongTC => _markModel.profile.TongTC;

  get getSTCTD => _markModel.profile.STCTD;

  get getDTBC => _markModel.profile.DTBC;

  get getDTBCQD => _markModel.profile.DTBCQD;

  get getSTCTLN => _markModel.profile.STCTLN;

  get getSoMonKhongDat => _markModel.profile.SoMonKhongDat;

  get getSoTCKhongDat => _markModel.profile.SoTCKhongDat;

  void loadCurrentMSV() async {
//    String value = await PlatformChannel.database
//        .invokeMethod(PlatformChannel.getCurrentMSV);
//    _markModel.msv = value;
//    if (value.isNotEmpty) {
//      loadProfile();
//      loadMarks();
//    }
  }

  void loadProfile() async {
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

  void loadMarks() async {
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
      _markModel.listMark = List<Mark>();
      var jsonData = json.decode(value);
      for (var item in jsonData) {
        _markModel.listMark.add(Mark.fromJson(item));
      }
    } else {
      //TODO()
    }
  }

  void _initProfile(String value) {
    if (value.isNotEmpty) {
      var jsonData = json.decode(value);
      _markModel.profile = Profile.fromJson(jsonData);
      _markModel.profile.setMoreDetailByJson(jsonData);
    } else {
      print('value profile is empty');
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

  actionFilter(String type) {
    _markModel.filterType = type;
    notifyListeners();
  }
}
