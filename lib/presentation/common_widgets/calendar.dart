// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Project imports:
import 'package:studentsocial/helpers/viet_calendar.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:studentsocial/presentation/screens/main/main_providers.dart';

final vietCalendar = VietCalendar();
final calendarViewProvider = StateProvider<CalendarView>((ref) {
  return CalendarView.month;
});

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({this.schedules, this.onTap, this.controller});

  final List<Schedule> schedules;
  final Function(CalendarTapDetails) onTap;
  final CalendarController controller;

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.addPropertyChangedListener((value) {
        context.read(dateSelectedProvider).state =
            widget.controller.selectedDate;
      });
    });
  }

  CalendarHeaderStyle calendarHeaderStyle = CalendarHeaderStyle(
      textAlign: TextAlign.center,
      textStyle:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));

  MonthViewSettings monthViewSettings = MonthViewSettings(
    showAgenda: true,
    dayFormat: 'EEE',
    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
    agendaViewHeight: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch, child) {
        final calendarView = watch(calendarViewProvider).state;
        if (calendarView == CalendarView.month) {
          return _calendarMonth();
        }
        return _calendarSchedule();
      },
    );
  }

  Widget _calendarSchedule() {
    return SfCalendar(
      controller: widget.controller,
      firstDayOfWeek: 1,
      headerStyle: calendarHeaderStyle,
      initialSelectedDate: DateTime.now(),
      view: CalendarView.schedule,
      dataSource: ScheduleDataSource(widget.schedules),
      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display mode
      // property
      monthViewSettings: monthViewSettings,
      showNavigationArrow: true,
      onTap: (details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          widget.onTap?.call(details);
        }
      },
    );
  }

  Widget _calendarMonth() {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: SfCalendar(
            controller: widget.controller,
            firstDayOfWeek: 1,
            headerStyle: calendarHeaderStyle,
            initialSelectedDate: DateTime.now(),
            view: CalendarView.month,
            dataSource: ScheduleDataSource(widget.schedules),
            // by default the month appointment display mode set as Indicator, we can
            // change the display mode as appointment using the appointment display mode
            // property
            monthViewSettings: monthViewSettings,
            showNavigationArrow: true,
            onTap: (details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                widget.onTap?.call(details);
              }
            },
          ),
        ),
        Consumer(
          builder: (ctx, watch, child) {
            final date = watch(dateSelectedProvider).state;
            return Expanded(
                child: ListScheduleWidget(
                    date: date, schedules: widget.schedules));
          },
        )
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

  Widget dateTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: currentDateTitle(context),
    );
  }

  Widget currentDateTitle(BuildContext context) {
    final al = vietCalendar.lichAm(date.day, date.month, date.year);
    return Column(
      children: [
        const Text(
          'Âm lịch',
          style: TextStyle(color: Colors.blueAccent),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            '${al[0]}/${al[1]}\n${al[2]}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
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
    return '${appointments[index].diaDiemClean} ${appointments[index].hocPhanClean}';
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
