// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, prefer_final_fields, must_be_immutable

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:simple_parking_app/model/user.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:get/get.dart';
import 'package:simple_parking_app/utils/data_pref.dart';
import 'package:simple_parking_app/utils/widgets/text_field_widgets.dart';
import 'package:simple_parking_app/view/auth/login_page.dart';
import '../../utils/widgets/loading_screen.dart';

class ProfilePage extends StatelessWidget {
  final String userID;

  ProfilePage(this.userID);

  final TextEditingController _tfName = TextEditingController();
  final TextEditingController _tfEmail = TextEditingController();
  final TextEditingController _tfPhoneNumber = TextEditingController();
  final TextEditingController _tfPassword = TextEditingController();

  var _isEdit = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "PROFILKU",
          style: TextStyle(
            color: Color(0xff06113D),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: ColorsTheme.myDarkBlue),
            onPressed: () async {
              await DataPref.clearData();
              Get.offAndToNamed(LoginPage.TAG);
            },
          )
        ],
      ),
      body: FutureBuilder<User>(
        future: ApiServices.getUserData(userID: userID),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return LoadingScreen();
          } else {
            _tfName.text = snapshot.data!.nama!;
            _tfEmail.text = snapshot.data!.email!;
            _tfPhoneNumber.text = snapshot.data!.noTelp!;
            _tfPassword.text = snapshot.data!.password!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //USER ICON
                  Icon(
                    Icons.person_rounded,
                    color: ColorsTheme.myDarkBlue,
                    size: 100,
                  ),

                  //TITLE
                  Text(
                    "Semua informasi tentang data diri dan akunmu.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 2,
                      color: ColorsTheme.myGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24),

                  //TEXT FIELD NAMA
                  ProfileTextField(
                    controller: _tfName,
                    title: 'Nama',
                    inputType: TextInputType.name,
                    editable: _isEdit,
                  ),

                  //TEXT FIELD EMAIL
                  ProfileTextField(
                    controller: _tfEmail,
                    title: 'Email',
                    inputType: TextInputType.emailAddress,
                    editable: _isEdit,
                  ),

                  //TEXT FIELD NO TELP
                  ProfileTextField(
                    controller: _tfPhoneNumber,
                    title: 'No.Telp',
                    inputType: TextInputType.number,
                    editable: _isEdit,
                  ),

                  //TEXT FIELD PASSWORD
                  ProfileTextField(
                    controller: _tfPassword,
                    title: 'Password',
                    inputType: TextInputType.number,
                    editable: _isEdit,
                  ),

                  SizedBox(height: 100),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Obx(
          () => FloatingActionButton.extended(
            backgroundColor: ColorsTheme.myOrange,
            icon: Icon(
              _isEdit.value ? Icons.done : Icons.edit,
              color: ColorsTheme.myDarkBlue,
            ),
            label: Text(
              _isEdit.value ? "SELESAI" : "EDIT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsTheme.myDarkBlue,
              ),
            ),
            onPressed: () {
              _isEdit.value = !_isEdit.value;
              if (!_isEdit.value) {
                editProfile();
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void editProfile() async {
    await ApiServices.editProfile(
      userID: userID,
      name: _tfName.text,
      email: _tfEmail.text,
      phoneNumber: _tfPhoneNumber.text,
      password: _tfPassword.text,
    ).then(
      (val) => Get.snackbar(
        val.error == true ? "Terjadi Kesalahan" : "Profil Berhasil Dirubah",
        val.message,
      ),
    );
  }
}