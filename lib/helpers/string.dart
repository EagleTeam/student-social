class StringSupport {
  static final Map<int, String> _dots = <int, String>{};
  String getDot(int count) {
    if (_dots[count] == null || _dots[count].isEmpty) {
      final stringBuffer = StringBuffer();
      for (var i = 0; i < count; i++) {
        stringBuffer.write('•');
      }
      _dots[count] = stringBuffer.toString();
      return stringBuffer.toString();
    } else {
      return _dots[count];
    }
  }
}
