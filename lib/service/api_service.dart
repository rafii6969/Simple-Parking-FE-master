import 'dart:convert';
import 'package:simple_parking_app/model/parking.dart';
import 'package:simple_parking_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:simple_parking_app/model/vehicle.dart';
import 'package:simple_parking_app/service/api.dart';
import '../model/response.dart';

abstract class ApiServices {
  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(Uri.parse(Api.login),
          body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['result'] != null) {
          return LoginResponse.fromJson(data);
        } else {
          return LoginResponse(
            error: data['error'],
            message: data['message'],
            result: null,
          );
        }
      } else {
        throw Exception('status code salah');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> signup({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(Uri.parse(Api.signup), body: {
        'nama': name,
        'no_telp': phoneNumber,
        'email': email,
        'password': password
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Response.fromJson(data);
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<User> getUserData({required String userID}) async {
    try {
      final response = await http.get(
        Uri.parse("${Api.getUserData}?id=$userID"),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> editProfile({
    required String userID,
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(Api.editProfile),
        body: {
          'id': userID,
          'nama': name,
          'no_telp': phoneNumber,
          'email': email,
          'password': password
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Response.fromJson(data);
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> topUp({
    required String userID,
    required String nominal,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(Api.topup),
        body: {'id': userID, 'saldo': nominal},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Response.fromJson(data);
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> addVehicle({
    required String userID,
    required String brand,
    required String model,
    required String color,
    required String number,
    required String type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Api.addVehicle),
        body: {
          'id_user': userID,
          'merek': brand,
          'model': model,
          'warna': color,
          'no_polisi': number,
          'jenis': type,
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Response.fromJson(data);
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response<List<Vehicle>?>> getAllVehicle(String userID) async {
    try {
      final response = await http.get(
        Uri.parse('${Api.showAllVehicle}?id_user=$userID'),
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return Response(
          error: responseData['error'],
          message: responseData['message'],
          result: List<Vehicle>.from(
            responseData["result"].map(
              (e) => Vehicle.fromJson(e),
            ),
          ),
        );
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response<User?>> getHomeInfo(String userID) async {
    try {
      final response = await http.get(
        Uri.parse('${Api.getHomeInfo}?id_user=$userID'),
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return Response(
          error: responseData['error'],
          message: responseData['message'],
          result: User.fromJson(responseData['result']),
        );
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response<Parking?>> getParkir(String userID) async {
    try {
      final response = await http.get(
        Uri.parse('${Api.getParkir}?id_user=$userID'),
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return Response(
          error: responseData['error'],
          message: responseData['message'],
          result: Parking.fromJson(responseData["result"]),
        );
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> payParking({
    required String parkingID,
    required String userID,
    required String cost,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(Api.payParking),
        body: {'id': parkingID, 'id_user': userID, 'cost': cost},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Response.fromJson(data);
      } else {
        throw Exception('404 not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
