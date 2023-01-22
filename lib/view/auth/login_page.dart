// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names, prefer_const_declarations, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_parking_app/main.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/data_pref.dart';
import 'package:simple_parking_app/view/auth/signup_page.dart';

class LoginPage extends StatelessWidget {
  static final String TAG = '/LoginPage';

  final _tfEmail = TextEditingController();
  final _tfPassword = TextEditingController();

  final _isPasswordVisible = true.obs;
  final _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "MASUK",
          style: TextStyle(
            color: Color(0xff06113D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(32, 24, 32, 32),
        child: Column(
          children: [
            //GAMBAR
            Image.asset(
              'assets/images/login.png',
              width: double.maxFinite,
              height: 200,
            ),

            //CAPTION
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 32),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.myDarkBlue),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Bersama simple parking, parkir menjadi lebih mudah dan praktis.",
                      style: TextStyle(
                        height: 1.5,
                        color: ColorsTheme.myGrey,
                      ),
                    ),
                  )
                ],
              ),
            ),

            //TEXT FIELD EMAIL
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: TextField(
                controller: _tfEmail,
                keyboardType: TextInputType.emailAddress,
                cursorColor: ColorsTheme.myOrange,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                    borderSide: BorderSide(color: ColorsTheme.myOrange),
                  ),
                  focusColor: ColorsTheme.myOrange,
                ),
              ),
            ),

            //TEXT FIELD PASSWORD
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Obx(
                () => TextField(
                  controller: _tfPassword,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: ColorsTheme.myOrange,
                  autocorrect: false,
                  obscureText: _isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: _isPasswordVisible.value
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        _isPasswordVisible.value = !_isPasswordVisible.value;
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      borderSide: BorderSide(color: ColorsTheme.myOrange),
                    ),
                    focusColor: ColorsTheme.myOrange,
                  ),
                ),
              ),
            ),

            //BUTON MASUK
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ColorsTheme.myDarkBlue,
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
                                color: Colors.grey,
                              ),
                            )
                          : SizedBox(),
                      Text(
                        "MASUK",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isLoading.value ? Colors.grey : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _isLoading.value
                      ? null
                      : () async {
                          await doLogin();
                        },
                ),
              ),
            ),

            //BUTTON DAFTAR
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: ColorsTheme.myLightOrange,
                  side: BorderSide(color: ColorsTheme.myOrange, width: 1.5),
                  minimumSize: Size(double.maxFinite, 50),
                  shape: StadiumBorder(),
                ),
                child: Text(
                  "DAFTAR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorsTheme.myOrange,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(SignupPage.TAG);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> doLogin() async {
    _isLoading.value = !_isLoading.value;
    await ApiServices.login(
      email: _tfEmail.text,
      password: _tfPassword.text,
    ).then(
      (data) async {
        if (data.error || data.result == null) {
          _isLoading.value = !_isLoading.value;
          loginFailed();
        } else {
          var userID = data.result!.id!;
          await DataPref.setUserId(userID.toString());
          _isLoading.value = !_isLoading.value;
          Get.offAndToNamed('${NavBar.TAG}/$userID');
        }
      },
    );
  }

  loginFailed() {
    //SHOWING LOGIN FAILED DIALOG
    Get.defaultDialog(
      radius: 16,
      title: "Oppss.. Terjadi kesalahan!",
      titlePadding: EdgeInsets.symmetric(vertical: 16),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorsTheme.myDarkBlue,
      ),
      content: Text(
        "Email/password yang dimasukan tidak valid atau salah",
        textAlign: TextAlign.center,
        style: TextStyle(
          height: 1.5,
          color: ColorsTheme.myGrey,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      textCancel: "Kembali",
    );
  }
}
