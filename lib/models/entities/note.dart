class Note {
  final String tieuDe;
  final String noiDung;
  final String date;

  Note({this.tieuDe, this.noiDung, this.date});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        tieuDe: json['tieuDe'].toString(),
        noiDung: json['noiDung'].toString(),
        date: json['date'].toString());
  }
  Map<String, String> toJson() {
    return {'tieuDe': tieuDe, 'noiDung': noiDung, 'date': date};
  }
}
