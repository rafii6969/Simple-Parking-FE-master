// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, implementation_imports, unused_import, non_constant_identifier_names, prefer_const_declarations, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simple_parking_app/model/vehicle.dart';
import 'package:simple_parking_app/service/api.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/widgets/loading_screen.dart';
import 'package:simple_parking_app/utils/widgets/text_widgets.dart';
import 'package:simple_parking_app/view/vehicle/add_vehicle_page.dart';
import 'package:http/http.dart' as http;

class ParkingPage extends StatelessWidget {
  static final String TAG = '/ParkingPage';

  final userID = Get.parameters['userID'];

  final _selectedItemID = Rxn<String>();
  final _selectedItemModel = Rxn<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: ColorsTheme.myDarkBlue,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "PARKIR",
          style:
              TextStyle(color: Color(0xff06113D), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TIPS & TRICK
            SubtitleText(text: "Tips & Trik"),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 24),
              padding: EdgeInsets.all(16),
              width: double.maxFinite,
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
              child: Text(
                "Arahkan Kode QR ke mesin palang parkir otomatis saat anda ingin memasuki area parkir",
                style: TextStyle(
                  color: ColorsTheme.myGrey,
                ),
              ),
            ),

            //KODE QR
            SubtitleText(text: "Kode QR"),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 24),
              padding: EdgeInsets.all(30),
              width: double.maxFinite,
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: Obx(
                  () => _showQRcode(
                    id: _selectedItemID.value,
                    model: _selectedItemModel.value,
                  ),
                ),
              ),
            ),

            //PILIH KENDDARAAN
            SubtitleText(text: "Pilih Kendaraan"),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: DropdownSearch<Vehicle>(
                clearButtonProps: ClearButtonProps(isVisible: true),
                dropdownButtonProps: DropdownButtonProps(isVisible: false),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorsTheme.myDarkBlue,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsTheme.myOrange),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                dropdownBuilder: (context, selectedItem) {
                  return Text(selectedItem?.model ?? "Pilih Kendaraan");
                },
                popupProps: PopupProps.modalBottomSheet(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.25,
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Pilih Kendaraan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.myDarkBlue,
                      ),
                    ),
                  ),
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item.model!),
                      subtitle: Text(
                        "${item.noPolisi} • ${item.jenis == 'B' ? "Mobil" : "Sepeda Motor"} • ${item.warna}",
                        style: TextStyle(height: 2),
                      ),
                    );
                  },
                  emptyBuilder: (context, item) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Oppss! Kamu belum menambahkan kendaraanmu, tambahkan kendaraanmu terlebih dahulu yaa :D",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.75,
                            color: ColorsTheme.myGrey,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorsTheme.myDarkBlue,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            "+ KENDARAAN",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.back();
                            Get.toNamed('${AddVehiclePage.TAG}/$userID');
                          },
                        ),
                      ],
                    );
                  },
                  loadingBuilder: (context, _) => LoadingScreen(),
                ),
                asyncItems: (text) async {
                  return await ApiServices.getAllVehicle(userID!).then(
                    (value) {
                      if (value.result!.isEmpty) {
                        return [];
                      } else {
                        return value.result!;
                      }
                    },
                  );
                },
                onChanged: (val) {
                  _selectedItemID.value = val?.id;
                  _selectedItemModel.value = val?.model;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showQRcode({required String? id, required String? model}) {
    if (id == null || model == null) {
      return Text("Pilih Kendaraan");
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            model,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          QrImage(
            data: id,
            size: 250,
          ),
        ],
      );
    }
  }
}
