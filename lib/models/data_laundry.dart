class Data {
  int id;
  String name;
  int berat;

  Data({required this.id, required this.name, required this.berat});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["nama_pemesan"],
        berat: json["berat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pemesan": name,
        "berat": berat,
      };
}
