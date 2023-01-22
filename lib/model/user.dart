class LoginResponse {
  bool error;
  String message;
  User? result;

  LoginResponse({
    required this.error,
    required this.message,
    required this.result,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json["error"],
      message: json["message"],
      result: User.fromJson(json['result']),
    );
  }
}

class User {
  int? id;
  String? nama;
  String? noTelp;
  String? email;
  String? password;
  String? saldo;
  String? jmlMobil = "0";
  String? jmlMotor = "0";

  User({
    required this.id,
    required this.nama,
    this.noTelp,
    this.email,
    this.password,
    this.saldo,
    this.jmlMobil,
    this.jmlMotor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      nama: json["nama"],
      noTelp: json["no_telp"],
      email: json["email"],
      password: json["password"],
      saldo: json["saldo"],
      jmlMobil: json["jml_mobil"],
      jmlMotor: json["jml_motor"],
    );
  }
}