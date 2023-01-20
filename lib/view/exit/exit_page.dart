// ignore_for_file: non_constant_identifier_names, prefer_const_declarations, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, must_be_immutable, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simple_parking_app/model/parking.dart';
import 'package:simple_parking_app/model/response.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/formater.dart';
import 'package:simple_parking_app/utils/widgets/loading_screen.dart';
import 'package:simple_parking_app/utils/widgets/text_widgets.dart';

class ExitPage extends StatelessWidget {
  static final String TAG = '/ExitPage';

  final _userID = Get.parameters['userID'];

  final _isLoading = false.obs;
  final _isPaid = Rxn<bool>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<Parking?>>(
      future: ApiServices.getParkir(_userID!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: BackButton(
                color: ColorsTheme.myDarkBlue,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Mohon Tunggu",
                style: TextStyle(
                  color: Color(0xff06113D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: LoadingScreen(),
          );
        } else {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: BackButton(
                  color: ColorsTheme.myDarkBlue,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  "404 Error",
                  style: TextStyle(
                    color: Color(0xff06113D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Center(
                child: Text("Terjadi Kesalahan"),
              ),
            );
          } else {
            var data = snapshot.data!.result!;
            var kendaraan = data.kendaraan;
            var tempat = data.tempat;

            _isPaid.value = data.status == "M" ? false : true;

            var tarif =
                kendaraan.jenis == "B" ? tempat.tarifMobil : tempat.tarifMotor;

            var durasi = data.waktuBayar == null
                ? Formater.timeDifference(data.waktuMasuk)
                : Formater.timeDifference(data.waktuMasuk, w2: data.waktuBayar);

            var cost = parkingCost(
              cost: kendaraan.jenis == 'B'
                  ? tempat.tarifMobil
                  : tempat.tarifMotor,
              duration: Formater.timeDiffInHours(data.waktuMasuk),
            );

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: BackButton(
                  color: ColorsTheme.myDarkBlue,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  "${data.status == "M" ? "BAYAR" : "KELUAR"} PARKIR",
                  style: TextStyle(
                    color: Color(0xff06113D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //STATUS PEMBAYARAN
                    Obx(
                      () => Container(
                        padding: EdgeInsets.all(16),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isPaid.value!
                                ? Colors.green
                                : ColorsTheme.myLightOrange,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "STATUS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isPaid.value!
                                    ? Colors.green
                                    : ColorsTheme.myLightOrange,
                              ),
                            ),
                            Text(
                              _isPaid.value!
                                  ? "Telah Dibayar"
                                  : "Menunggu Pembayaran",
                              style: TextStyle(
                                fontSize: 16,
                                color: _isPaid.value!
                                    ? Colors.green
                                    : ColorsTheme.myLightOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //INFO PARKIR & Kendaraan
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: SubtitleText(text: "Info Parkir & Kendaraan"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ColorsTheme.myDarkBlue,
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //NAMA TEMPAT PARKIR
                          Center(
                            child: Text(
                              "${tempat.nama} ${tempat.kota}".toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorsTheme.myDarkBlue,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            height: 36,
                            color: ColorsTheme.myLightOrange,
                          ),
                          infoField(
                            title: "Tanggal Masuk",
                            info: Formater.date(data.waktuMasuk),
                          ),
                          infoField(
                            title: "Waktu Masuk",
                            info: "${Formater.time(data.waktuMasuk)} WIB",
                          ),
                          infoField(
                            title: "Kendaraan",
                            info: "${kendaraan.merek} ${kendaraan.model}",
                          ),
                          infoField(
                            title: "Plat Nomor",
                            info: kendaraan.noPolisi!,
                          ),
                          infoField(
                            title: "Tipe Kendaraan",
                            info: kendaraan.jenis == "B" ? "Mobil" : "Motor",
                          ),
                        ],
                      ),
                    ),

                    //INFO TAGIHAN
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: SubtitleText(text: "Tagihan"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ColorsTheme.myDarkBlue,
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoField(
                            title: "Tarif Parkir",
                            info: "Rp ${Formater.toIDR(tarif)}/Jam",
                          ),

                          infoField(title: "Durasi Parkir", info: durasi),

                          Divider(thickness: 2, height: 44),

                          //TOTAL BIAYA PARKIR
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Biaya Parkir",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsTheme.myDarkBlue,
                                ),
                              ),
                              Text(
                                data.biaya == null
                                    ? "Rp ${Formater.toIDR(cost)}"
                                    : "Rp ${Formater.toIDR(data.biaya!)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsTheme.myDarkBlue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 120),
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorsTheme.myLightOrange,
                      shape: StadiumBorder(),
                      minimumSize: Size(double.maxFinite, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isLoading.value
                            ? Container(
                                margin: const EdgeInsets.only(right: 16),
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: ColorsTheme.myDarkBlue,
                                ),
                              )
                            : SizedBox(),
                        Text(
                          buttonState(
                            _isPaid.value!,
                            _isLoading.value,
                          ), //isPaid.value ? "KELUAR PARKIR" : "BAYAR",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorsTheme.myDarkBlue,
                          ),
                        ),
                      ],
                    ),
                    onPressed: _isLoading.value
                        ? null
                        : () async => payParking(context, data, cost),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          }
        }
      },
    );
  }

  Future<void> payParking(
    BuildContext context,
    Parking data,
    String cost,
  ) async {
    _isLoading.value = !_isLoading.value;
    if (data.status == "M") {
      await ApiServices.payParking(
        parkingID: data.id,
        userID: data.idUser,
        cost: cost,
      ).then(
        (value) {
          if (value.error) {
            _isLoading.value = !_isLoading.value;
            showErrorMessage(context);
          } else {
            _isPaid.value = true;
            _isLoading.value = !_isLoading.value;
            showExitQRCode(context, data.id);
          }
        },
      );
    } else {
      _isLoading.value = !_isLoading.value;
      showExitQRCode(context, data.id);
    }
  }

  Future<dynamic> showErrorMessage(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 24),
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Text(
                "PEMBAYARAN GAGAL",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.myDarkBlue,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.error_rounded,
                      size: 130,
                      color: Colors.redAccent,
                    ),
                    Text(
                      "Oppss.. Telah terjadi kesalahan. Pastikan saldo kamu cukup untuk melakukan pembayaran!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.75),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showExitQRCode(BuildContext context, String idParkir) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 24),
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Text(
                "PEMBAYARAN BERHASIL",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.myDarkBlue,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      child: QrImage(
                        data: idParkir,
                        size: 200,
                      ),
                    ),
                    Text(
                      "Gunakan Kode QR ini saat hendak keluar dari area parkir",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.75),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String parkingCost({required String cost, required String duration}) {
    var parkingCost = int.parse(cost) * int.parse(duration);
    return parkingCost.toString();
  }

  Padding infoField({required String title, required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: ColorsTheme.myDarkBlue,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 15,
              color: ColorsTheme.myDarkBlue,
            ),
          ),
        ],
      ),
    );
  }

  String buttonState(bool isPaid, bool isLoading) {
    if (!isPaid) {
      if (isLoading) {
        return "MEMPROSES...";
      }
      return "BAYAR PARKIR";
    }
    return "KELUAR PARKIR";
  }
}
