import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/entities/mark.dart';
import 'mark_notifier.dart';

class MarkScreen extends StatefulWidget {
  @override
  _MarkScreenState createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  String mark;
  Map<String, String> subjectsName = <String, String>{};
  Map<String, String> subjectsSoTinChi = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu điểm'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
//                loading(context, 'Đang tải dữ liệu');
                _updateMark();
              })
        ],
      ),
      body: _mainView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogLocDiem();
        },
        child: const Text('Lọc'),
      ),
    );
  }

  Widget _layoutItemMark(int index) {
    final Mark mark = context.read(markProvider).getListMark()[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
            child: Text(
              '${mark.TenMon} (${mark.SoTinChi}TC)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text('CC'),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        mark.CC.isNotEmpty ? mark.CC : '  ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text('THI'),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(mark.THI.isNotEmpty ? mark.THI : '   ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text('TKHP'),
                      const SizedBox(height: 4),
                      Text(mark.TKHP.isNotEmpty ? mark.TKHP : '    ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text('XL'),
                      CircleAvatar(
                          radius: 14,
                          backgroundColor: _getColorDiemChu(mark.DiemChu),
                          child: Text(
                              mark.DiemChu.isNotEmpty ? mark.DiemChu : '  ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorDiemChu(String diemChu) {
    if (diemChu.isNotEmpty) {
      if (diemChu == 'A') {
        return Colors.green;
      }
      if (diemChu == 'B') {
        return Colors.blue;
      }
      if (diemChu == 'C') {
        return Colors.orange;
      }
      if (diemChu == 'D') {
        return Colors.yellow;
      }
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Widget layoutDiem() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          snap: true,
          floating: true,
          automaticallyImplyLeading: false,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  'Tổng TC: ${context.read(markProvider).getTongTC}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              const Padding(padding: EdgeInsets.only(left: 16)),
                              Text(
                                  'STCTD: ${context.read(markProvider).getSTCTD}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                              ),
                              Text(
                                  'STCTLN: ${context.read(markProvider).getSTCTLN}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'ĐTB HS10: ${context.read(markProvider).getDTBC}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                              ),
                              Text(
                                  'ĐTB HS4: ${context.read(markProvider).getDTBCQD}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                              'Số môn không đạt: ${context.read(markProvider).getSoMonKhongDat}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                              'Số tín chỉ không đạt: ${context.read(markProvider).getSoTCKhongDat}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
              padding: const EdgeInsets.only(bottom: 1),
              child: _layoutItemMark(index));
        }, childCount: context.read(markProvider).getListMark().length))
      ],
    );
  }

  Widget layoutTrong() {
    return const Center(child: Text('Không có dữ liệu :('));
  }

  Widget _mainView() {
    //chon man hinh hien thi tuy theo du lieu
    if (context.read(markProvider).getListMark == null) {
      //mac dinh
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (context.read(markProvider).getListMark() != null &&
        context.read(markProvider).getListMark().isNotEmpty) {
      return layoutDiem();
    } else {
      return layoutTrong();
    }
  }

  Future<void> _updateMark() async {
//    mark = await _netWorking.getMark(context.read(markProvider).getToken);
    addSubjects(mark);
    //validate diem
    validateMark();
    await saveMarkToDB();
    context.read(markProvider).loadCurrentMSV();
//    await showSuccess(context,'Cập nhật điểm thành công');
//    pop(context);
  }

  void addSubjects(value) {
    final jsonValue = json.decode(value);
    final listSubjects = jsonValue['Subjects'];
    for (var item in listSubjects) {
      addSubjectsName(item['MaMon'], item['TenMon']);
      addSubjectsSoTinChi(item['MaMon'], item['SoTinChi'].toString());
    }
  }

  void addSubjectsName(maMon, tenMon) {
    subjectsName[maMon] = tenMon;
  }

  void addSubjectsSoTinChi(maMon, String soTinChi) {
    subjectsSoTinChi[maMon] = soTinChi;
  }

  void validateMark() {
    mark = mark.substring(mark.indexOf('['));
    mark = mark.substring(0, mark.indexOf(']') + 1);
  }

  Future<void> saveMarkToDB() async {
    //TODO: save mark to db
//    var res = await PlatformChannel().saveMarkToDB(
//        mark,
//        json.encode(subjectsName),
//        json.encode(subjectsSoTinChi),
//        context.read(markProvider).getMSV);
//    print('saveMarkToDB: $res');
  }

  void _showDialogLocDiem() {
    final AlertDialog alertDialog = AlertDialog(
      title: const Text('Lọc điểm'),
      contentPadding: const EdgeInsets.all(8),
      content: Container(
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                  title: const Text('Tất cả'),
                  onTap: () {
                    context.read(markProvider).actionFilter('ALL');
                    Navigator.of(context).pop();
                  }),
              const Divider(height: 4),
              ListTile(
                title: const Text('Xếp loại A'),
                onTap: () {
                  context.read(markProvider).actionFilter('A');
                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 4),
              ListTile(
                title: const Text('Xếp loại B'),
                onTap: () {
                  context.read(markProvider).actionFilter('B');
                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 4),
              ListTile(
                title: const Text('Xếp loại C'),
                onTap: () {
                  context.read(markProvider).actionFilter('C');
                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 4),
              ListTile(
                title: const Text('Xếp loại D'),
                onTap: () {
                  context.read(markProvider).actionFilter('D');
                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 4),
              ListTile(
                title: const Text('Xếp loại F'),
                onTap: () {
                  context.read(markProvider).actionFilter('F');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('HUỶ BỎ'),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
