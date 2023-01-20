// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:simple_parking_app/model/parking.dart';
import 'package:simple_parking_app/model/response.dart';
import 'package:simple_parking_app/model/user.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/formater.dart';
import 'package:simple_parking_app/utils/widgets/loading_screen.dart';
import 'package:simple_parking_app/utils/widgets/text_widgets.dart';
import 'package:simple_parking_app/view/exit/exit_page.dart';
import 'package:simple_parking_app/view/home/parking_act_widget.dart';
import 'package:simple_parking_app/view/parking/parking_page.dart';
import 'package:simple_parking_app/view/top_up/top_up_page.dart';
import '../vehicle/add_vehicle_page.dart';

class HomePage extends StatelessWidget {
  final String userID;

  const HomePage(this.userID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<User?>>(
      future: ApiServices.getHomeInfo(userID),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LoadingScreen();
        } else {
          var user = snapshot.data!.result!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  //USER AVATAR
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsTheme.myDarkBlue,
                    ),
                    child: Center(
                      child: Text(
                        getInitials(user.nama!),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  //USER NAME
                  Text(
                    user.nama!,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsTheme.myDarkBlue,
                    ),
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //AKTIFITAS PARKIR WIDGETS
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //WIDGET AKTIVITAS PARKIR
                        FutureBuilder<Response<Parking?>>(
                          future: ApiServices.getParkir(userID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return loadingParkingAct();
                            } else {
                              if (!snapshot.hasData) {
                                return emptyParkingWidget();
                              } else {
                                var data = snapshot.data!.result!;
                                var kendaraan = data.kendaraan;
                                var tempat = data.tempat;
                                return CardParkingActivity(
                                  placeName: tempat.nama,
                                  city: tempat.kota,
                                  vehicleType: kendaraan.jenis!,
                                  vehicleBrand: kendaraan.merek,
                                  vehicleModel: kendaraan.model!,
                                  policeNumber: kendaraan.noPolisi!,
                                  dateTime: data.waktuMasuk,
                                  onTap: () {
                                    Get.toNamed('${ExitPage.TAG}/$userID');
                                  },
                                );
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),

                  //SALDO WIDGETS
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TITILE SALDO
                        SubtitleText(text: "Saldo"),

                        //WIDGET SALDO
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.all(10),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: ColorsTheme.myDarkBlue),
                              bottom: BorderSide(color: ColorsTheme.myDarkBlue),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp ${Formater.toIDR(user.saldo!)} ,-",
                                style: TextStyle(
                                  color: ColorsTheme.myDarkBlue,
                                  fontSize: 20,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: ColorsTheme.myDarkBlue,
                                  shape: StadiumBorder(),
                                ),
                                child: Text(
                                  "+ SALDO",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Get.toNamed('${TopUpPage.TAG}/$userID');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //TITLE KENDARAAN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SubtitleText(text: "Kendaraan"),
                  ),

                  //WIDGET LIST KENDARAAN
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        cardVehicle(
                          vehicleType: "Mobil",
                          amount: int.parse(user.jmlMobil!),
                          imageFile: "car.png",
                        ),
                        cardVehicle(
                          vehicleType: "Sepeda Motor",
                          amount: int.parse(user.jmlMotor!),
                          imageFile: "motorbike.png",
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),

                  //BUTTON +KENDARAAN
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ColorsTheme.myDarkBlue,
                          shape: StadiumBorder(),
                          minimumSize: Size(double.maxFinite, 50)),
                      child: Text(
                        "+ KENDARAAN",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed('${AddVehiclePage.TAG}/$userID');
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  GestureDetector emptyParkingWidget() {
    return GestureDetector(
      child: SizedBox(
        height: 220,
        width: double.maxFinite,
        child: Image.asset(
          'assets/images/empty_parking.png',
        ),
      ),
      onTap: () {
        Get.toNamed('${ParkingPage.TAG}/$userID');
      },
    );
  }

  SizedBox loadingParkingAct() {
    return SizedBox(
      width: double.maxFinite,
      height: 220,
      child: LoadingScreen(),
    );
  }

  String getInitials(String string) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (split.length > 2 ? 2 : split.length); i++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }

  Container cardVehicle({
    required String vehicleType,
    required int amount,
    required String imageFile,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      padding: EdgeInsets.all(16),
      width: 325,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(227, 255, 185, 99),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/$imageFile'),
          SizedBox(width: 32),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicleType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsTheme.myDarkBlue,
                  ),
                ),
                Text("$vehicleType yang terdaftar : $amount Unit"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
