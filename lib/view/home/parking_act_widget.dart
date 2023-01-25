// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/formater.dart';

class CardParkingActivity extends StatelessWidget {
  final String placeName;
  final String vehicleType;
  final String vehicleModel;
  final String policeNumber;
  final String dateTime;
  final String? city;
  final String? vehicleBrand;
  final VoidCallback? onTap;

  const CardParkingActivity({
    required this.placeName,
    required this.vehicleType,
    required this.vehicleModel,
    required this.policeNumber,
    required this.dateTime,
    this.city = "",
    this.vehicleBrand = "",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorsTheme.myDarkBlue,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ColorsTheme.myLightOrange, ColorsTheme.myOrange],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TITLE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //NAMA TEMPAT PARKIR
                        Text(
                          "$placeName $city",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        //INFO KENDARAAN
                        Text(
                          "${vehicleType == "B" ? "Mobil" : "Sepeda Motor"} • $vehicleBrand $vehicleModel • $policeNumber",
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.75,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    //DATE TIME
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        SizedBox(width: 8),
                        Text(
                          dateTime,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    //DURASI
                    Row(
                      children: [
                        Icon(Icons.timelapse_outlined),
                        SizedBox(width: 8),
                        Text(
                          dateTime,
                          // "5 Jam 10 Menit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //TOTAL BIAYA PARKIR
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bayar & Keluar Parkir",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsTheme.myLightOrange,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsTheme.myLightOrange,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
