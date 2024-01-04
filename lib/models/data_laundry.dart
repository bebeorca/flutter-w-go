class Data {
  int id;
  int userId;
  int berat;
  String name;
  String deskripsi;

  Data({
    required this.id,
    required this.userId,
    required this.name,
    required this.berat,
    required this.deskripsi,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        name: json["nama_pemesan"],
        berat: json["berat"],
        deskripsi: json["deskripsi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user)_id": userId,
        "nama_pemesan": name,
        "berat": berat,
        "deskripsi": deskripsi,
      };
}
