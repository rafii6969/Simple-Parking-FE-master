import 'dart:convert';

import 'package:simple_parking_app/model/parking_place.dart';
import 'package:simple_parking_app/model/vehicle.dart';

class Parking {
  String id;
  String idUser;
  Vehicle kendaraan;
  ParkingPlace tempat;
  String waktuMasuk;
  String? waktuBayar;
  String? waktuKeluar;
  String? biaya;
  String status;

  Parking({
    required this.id,
    required this.idUser,
    required this.kendaraan,
    required this.tempat,
    required this.status,
    required this.waktuMasuk,
    this.waktuBayar,
    this.waktuKeluar,
    this.biaya,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json["id"],
      idUser: json["id_user"],
      kendaraan: Vehicle.fromJson(json["kendaraan"]),
      tempat: ParkingPlace.fromJson(json["tempat"]),
      waktuMasuk: json["waktu_masuk"],
      waktuBayar: json["waktu_bayar"],
      waktuKeluar: json["waktu_keluar"],
      biaya: json["biaya"],
      status: json["status"],
    );
  }
}
