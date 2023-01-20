// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../colors_theme.dart';

class LoadingScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorsTheme.myOrange),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Sedang Memuat..."),
          ),
        ],
      ),
    );
  }
}