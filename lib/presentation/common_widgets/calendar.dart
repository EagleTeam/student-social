import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studentsocial/helpers/logging.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({this.schedules, this.onTap});

  final List<Schedule> schedules;
  final Function(CalendarTapDetails) onTap;

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _date = DateTime.now();
  CalendarController calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
  }

  CalendarHeaderStyle calendarHeaderStyle = CalendarHeaderStyle(
      textAlign: TextAlign.center,
      textStyle:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));

  CalendarView calendarView = CalendarView.month;

  MonthViewSettings monthViewSettings = MonthViewSettings(
    showAgenda: true,
    dayFormat: 'EEE',
    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
    agendaViewHeight: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: SfCalendar(
            firstDayOfWeek: 1,
            headerStyle: calendarHeaderStyle,
            initialSelectedDate: DateTime.now(),
            view: calendarView,
            dataSource: ScheduleDataSource(widget.schedules),
            // by default the month appointment display mode set as Indicator, we can
            // change the display mode as appointment using the appointment display mode
            // property
            monthViewSettings: monthViewSettings,
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                if (widget.onTap != null) {
                  widget.onTap(details);
                }
                setState(() {
                  _date = details.date;
                });
              }
            },
          ),
        ),
        Expanded(
            child: ListScheduleWidget(date: _date, schedules: widget.schedules))
      ],
    );
  }
}

class ListScheduleWidget extends StatelessWidget {
  ListScheduleWidget({this.date, this.schedules}) {
    _appointments = List.from(schedules);
    _appointments.removeWhere((element) => !element.equalsDate(date));
  }

  final DateTime date;
  final List<Schedule> schedules;
  List<Schedule> _appointments = [];

  String titleDay(BuildContext context) {
    final DateFormat format =
        DateFormat('EEE', Localizations.localeOf(context).languageCode);
    return format.format(date);
  }

  Widget itemSchedule(int index) {
    if (_appointments[index].LoaiLich == 'LichHoc') {
      return itemLichHoc(_appointments[index]);
    } else {
      return itemLichThi(_appointments[index]);
    }
  }

  Widget itemLichHoc(dynamic schedule) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.hocPhanClean,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            '${schedule.thoiGian} tại ${schedule.diaDiemClean}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget itemLichThi(dynamic schedule) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.hocPhanClean,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Số báo danh: ${schedule.SoBaoDanh}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '${schedule.TietHoc} tại ${schedule.diaDiemClean}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  bool isCurrentDay() {
    final DateTime now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  Widget dateTitle(BuildContext context) {
    if (isCurrentDay()) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: currentDateTitle(context),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: normalDateTitle(context),
      );
    }
  }

  Widget currentDateTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          titleDay(context),
          style: const TextStyle(color: Colors.blueAccent),
        ),
        CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            date.day.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget normalDateTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          titleDay(context),
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          date.day.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dateTitle(context),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8, right: 10, bottom: 10),
            itemCount: _appointments.length,
            itemBuilder: (_, index) {
              return itemSchedule(index);
            },
            separatorBuilder: (_, __) {
              return const SizedBox(
                height: 10,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<Schedule> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments[index].HocPhan;
  }

  @override
  Color getColor(int index) {
    return appointments[index].LoaiLich == 'LichHoc'
        ? Colors.blueAccent
        : Colors.red;
  }

  @override
  String getNotes(int index) {
    return appointments[index].LoaiLich;
  }

  @override
  String getLocation(int index) {
    return appointments[index].DiaDiem;
  }
}
