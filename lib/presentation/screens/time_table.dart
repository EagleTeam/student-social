// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../helpers/date.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({this.msv});

  final String msv;

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<String> _time1;
  List<String> _time2;

  Future<void> _initTimeTable() async {
    //default to DTC
    _time1 = [
      '06:45 - 07:35',
      '07:40 - 08:30',
      '08:35 - 09:25',
      '09:30 - 10:20',
      '10:25 - 11:15',
      '13:00 - 13:50',
      '13:55 - 14:45',
      '14:50 - 15:40',
      '15:55 - 16:35',
      '16:40 - 17:30',
      '18:15 - 19:05',
      '19:10 - 20:00',
      '20:05 - 20:55',
      '21:00 - 21:55',
      '21:55 - 22:45',
    ];
    _time2 = [
      '07:00 - 07:50',
      '07:55 - 08:45',
      '08:50 - 09:40',
      '09:45 - 10:35',
      '10:40 - 11:30',
      '13:00 - 13:50',
      '13:55 - 14:45',
      '14:50 - 15:40',
      '15:55 - 16:35',
      '16:40 - 17:30',
      '18:15 - 19:05',
      '19:10 - 20:00',
      '20:05 - 20:55',
      '21:00 - 21:55',
      '21:55 - 22:45',
    ];
    if (widget.msv.startsWith('DTC')) {
      _time1 = [
        '06:30 - 07:20',
        '07:25 - 08:15',
        '08:25 - 09:15',
        '09:25 - 10:15',
        '10:20 - 11:10',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:55 - 15:45',
        '15:55 - 16:45',
        '16:50 - 17:40',
        '18:15 - 19:05',
        '19:10 - 20:00'
      ];
      _time2 = [
        '06:45 - 07:35',
        '07:40 - 08:30',
        '08:40 - 09:30',
        '09:40 - 10:30',
        '10:35 - 11:25',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:55 - 15:45',
        '15:55 - 16:45',
        '16:50 - 17:40',
        '18:15 - 19:05',
        '19:10 - 20:00'
      ];
    }
    if (widget.msv.startsWith('DTE')) {
      _time1 = [
        '06:45 - 07:35',
        '07:40 - 08:30',
        '08:35 - 09:25',
        '09:30 - 10:20',
        '10:25 - 11:15',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:50 - 15:40',
        '15:55 - 16:35',
        '16:40 - 17:30',
        '18:15 - 19:05',
        '19:10 - 20:00',
        '20:05 - 20:55',
        '21:00 - 21:55',
        '21:55 - 22:45',
      ];
      _time2 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:45 - 10:35',
        '10:40 - 11:30',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:50 - 15:40',
        '15:55 - 16:35',
        '16:40 - 17:30',
        '18:15 - 19:05',
        '19:10 - 20:00',
        '20:05 - 20:55',
        '21:00 - 21:55',
        '21:55 - 22:45',
      ];
    }
    if (widget.msv.startsWith('DTN')) {
      _time1 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:50 - 10:40',
        '10:45 - 11:35',
        '13:15 - 14:05',
        '14:10 - 15:00',
        '15:05 - 15:55',
        '16:05 - 16:55',
        '17:00 - 17:50',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
      ];
      _time2 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:50 - 10:40',
        '10:45 - 11:35',
        '13:15 - 14:05',
        '14:10 - 15:00',
        '15:05 - 15:55',
        '16:05 - 16:55',
        '17:00 - 17:50',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
        'Rỗng - Rỗng',
      ];
    }
  }

  DateSupport _dateSupport;
  int _tiet;

  @override
  void initState() {
    super.initState();
    _initTimeTable();
    _dateSupport = DateSupport();
    _tiet = _dateSupport.getTiet(widget.msv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời gian ra vào lớp'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            automaticallyImplyLeading: false,
            expandedHeight: 130,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 16, left: 8),
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Text('Lịch mùa hè bắt đầu từ 15/4',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Text('Lịch mùa đông bắt đầu từ 15/10',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12),
                      child: Text(
                          'Đóng góp thời gian biểu cho bọn mình qua trang fb Student Social nhé !',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 25)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 40,
              pinned: true,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(
                      'Tiết',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '    Mùa hè',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '    Mùa đông',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return Column(
              children: <Widget>[
                _getLayoutTime(index + 1),
                const Divider(height: 8)
              ],
            );
          }, childCount: 12))
        ],
      ),
    );
  }

  Widget _getLayoutTime(int index) {
    if (index != _tiet) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                '$index',
                style: const TextStyle(fontSize: 17),
              )),
            ),
            Expanded(
              flex: 3,
              child:
                  Text(_time1[index - 1], style: const TextStyle(fontSize: 17)),
            ),
            Expanded(
              flex: 3,
              child:
                  Text(_time2[index - 1], style: const TextStyle(fontSize: 17)),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                '$index',
                style: const TextStyle(color: Colors.red, fontSize: 17),
              )),
            ),
            Expanded(
              flex: 3,
              child: Text(_time1[index - 1],
                  style: const TextStyle(color: Colors.red, fontSize: 17)),
            ),
            Expanded(
              flex: 3,
              child: Text(_time2[index - 1],
                  style: const TextStyle(color: Colors.red, fontSize: 17)),
            ),
          ],
        ),
      );
    }
  }
}
