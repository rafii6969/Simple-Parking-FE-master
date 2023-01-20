// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_declarations, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:simple_parking_app/main.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/widgets/text_field_widgets.dart';
import 'package:simple_parking_app/utils/widgets/text_widgets.dart';

class AddVehiclePage extends StatelessWidget {
  static final String TAG = '/AddVehiclePage';

  final TextEditingController _tfBrand = TextEditingController();
  final TextEditingController _tfModel = TextEditingController();
  final TextEditingController _tfColor = TextEditingController();
  final TextEditingController _tfVehicleNumber_1 = TextEditingController();
  final TextEditingController _tfVehicleNumber_2 = TextEditingController();
  final TextEditingController _tfVehicleNumber_3 = TextEditingController();

  final userID = Get.parameters["userID"];

  final _selectedItem = Rxn<String>();

  final _vehicleType = [
    "Mobil",
    "Sepeda Motor",
  ];

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
          "+ KENDARAAN",
          style: TextStyle(
            color: Color(0xff06113D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //MERK KENDARAAN
            SubtitleText(text: "Merek"),
            AddVehicleTextField(controller: _tfBrand, title: "Toyota"),

            //MODEL KENDARAAN
            SubtitleText(text: "Model"),
            AddVehicleTextField(controller: _tfModel, title: "Avanza"),

            //WARNA
            SubtitleText(text: "Warna"),
            AddVehicleTextField(controller: _tfColor, title: "Hitam"),

            //PLAT NOMOR
            SubtitleText(text: "No.Polisi (Plat Nomor)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VehicleNumberTextField(
                  controller: _tfVehicleNumber_1,
                  hint: "B",
                  width: 50,
                  maxLength: 2,
                ),
                VehicleNumberTextField(
                  controller: _tfVehicleNumber_2,
                  hint: "1234",
                  width: 150,
                  maxLength: 4,
                  inputType: TextInputType.number,
                ),
                VehicleNumberTextField(
                  controller: _tfVehicleNumber_3,
                  hint: "ABC",
                  width: 100,
                  maxLength: 3,
                ),
              ],
            ),

            //JENIS KENDARAAN (DROP DOWN : MOTOR OR MOBIL)
            SubtitleText(text: "Jenis"),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Obx(
                () => DropdownSearch<String>(
                  items: _vehicleType,
                  dropdownButtonProps: DropdownButtonProps(isVisible: false),
                  clearButtonProps: ClearButtonProps(
                    isVisible: true,
                    color: ColorsTheme.myGrey,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Colors.grey.shade200,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorsTheme.myOrange),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  popupProps: PopupProps.modalBottomSheet(
                    showSelectedItems: true,
                    fit: FlexFit.loose,
                    constraints: BoxConstraints(minHeight: 180),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Jenis Kendaraan",
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
                        title: Text(item),
                      );
                    },
                  ),
                  selectedItem: _selectedItem.value ?? "Jenis Kendaraan",
                  onChanged: (newVal) => _selectedItem.value = newVal,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: ColorsTheme.myOrange,
            shape: StadiumBorder(),
            minimumSize: Size(double.maxFinite, 50),
          ),
          child: Text(
            "TAMBAHKAN",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsTheme.myDarkBlue,
            ),
          ),
          onPressed: () => addVehicle(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addVehicle() async {
    String brand = _tfBrand.text;
    String model = _tfModel.text;
    String color = _tfColor.text;
    String police_number = _tfVehicleNumber_1.text +
        _tfVehicleNumber_2.text +
        _tfVehicleNumber_3.text;

    if (brand.isEmpty ||
        model.isEmpty ||
        color.isEmpty ||
        police_number.isEmpty ||
        _selectedItem.value == null) {
      Get.snackbar("Terjadi Kesalahan", "Semua data harus diisi");
    } else {
      String type = _selectedItem.value! == "Mobil" ? "B" : "T";
      await ApiServices.addVehicle(
        userID: userID!,
        brand: brand,
        model: model,
        color: color,
        number: police_number,
        type: type,
      ).then((value) {
        Get.offAllNamed(NavBar.TAG);
        Get.snackbar("Sukses", "Berhasil Menambahkan Kendaraan");
      });
    }
  }
}
