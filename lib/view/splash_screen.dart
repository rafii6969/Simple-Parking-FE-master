// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_declarations, non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_parking_app/main.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/data_pref.dart';
import 'package:simple_parking_app/view/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  static final String TAG = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login.png',
              width: double.maxFinite,
              height: 200,
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: LinearProgressIndicator(
                backgroundColor: ColorsTheme.myOrange,
                valueColor: AlwaysStoppedAnimation(ColorsTheme.myDarkBlue),
              ),
            )
          ],
        ),
      ),
    );
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(
      duration,
      () async {
        await DataPref.getUserId().then(
          (val) {
            Get.offAndToNamed(
                val == null ? LoginPage.TAG : '${NavBar.TAG}/$val');
          },
        );
      },
    );
  }
}
