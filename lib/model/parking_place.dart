class ParkingPlace {
  String nama;
  String kota;
  String tarifMobil;
  String tarifMotor;

  ParkingPlace({
    required this.nama,
    required this.kota,
    required this.tarifMobil,
    required this.tarifMotor,
  });

  factory ParkingPlace.fromJson(Map<String, dynamic> json) {
    return ParkingPlace(
      nama: json["nama"],
      kota: json["kota"],
      tarifMobil: json["tarif_mobil"],
      tarifMotor: json["tarif_motor"],
    );
  }
}