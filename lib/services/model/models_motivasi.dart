class Motivasi {
  final int id;
  final String teks;
  final String pembuat;

  Motivasi({
    required this.id,
    required this.teks,
    required this.pembuat,
  });

  factory Motivasi.fromJson(Map<String, dynamic> json) {
    return Motivasi(
      id: json['id'],
      teks: json['teks'],
      pembuat: json['pembuat'],
    );
  }
}
