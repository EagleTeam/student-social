class CalendarStudentSocial {
  static const summary = 'Student Social lịch học';

  static Map<String, dynamic> toJson() {
    return {
      'accessRole': 'reader',
      'backgroundColor': '#4caf50',
      'colorId': '8',
      'conferenceProperties': {
        'allowedConferenceSolutionTypes': ['eventHangout']
      },
      'defaultReminders': [
        {'method': 'popup', 'minutes': 30}
      ],
      'etag': '${DateTime.now().microsecondsSinceEpoch}',
      'foregroundColor': '#000000',
      'kind': 'calendar#calendarListEntry',
      'selected': true,
      'summary': 'Student Social lịch học',
      'summaryOverride': 'Lịch học được đồng bộ từ Student Social',
      'timeZone': 'Asia/Ho_Chi_Minh'
    };
  }
}
