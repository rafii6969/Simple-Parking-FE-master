class Vehicle {
  Vehicle({
    this.id,
    this.idUser,
    this.merek,
    this.model,
    this.warna,
    this.noPolisi,
    this.jenis,
  });

  String? id;
  String? idUser;
  String? merek;
  String? model;
  String? warna;
  String? noPolisi;
  String? jenis;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"],
      idUser: json["id_user"],
      merek: json["merek"],
      model: json["model"],
      warna: json["warna"],
      noPolisi: json["no_polisi"],
      jenis: json["jenis"],
    );
  }
}
