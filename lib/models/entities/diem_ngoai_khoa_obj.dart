class DiemNgoaiKhoaObj {
  DiemNgoaiKhoaObj({this.id, this.title, this.status, this.score});
  factory DiemNgoaiKhoaObj.fromJson(Map<String, dynamic> json) {
    return DiemNgoaiKhoaObj(
        id: json['id'].toString(),
        title: json['title'],
        status: json['is_final'].toString(),
        score: json['score'].toString());
  }
  final String id, title, status, score;
}
