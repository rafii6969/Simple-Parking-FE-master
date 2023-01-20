// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_declarations, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_parking_app/main.dart';
import 'package:simple_parking_app/service/api_service.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';
import 'package:simple_parking_app/utils/formater.dart';
import 'package:simple_parking_app/utils/widgets/text_widgets.dart';

class TopUpPage extends StatefulWidget {
  static final String TAG = '/TopUpPage';

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  TextEditingController _tfNominal = TextEditingController();

  final userID = Get.parameters["userID"];

  var _isSelected = false.obs;
  var _itemSelected = 0.obs;
  bool _isBtnTopupActive = false;

  final List<int> _topUpItems = [
    50000,
    100000,
    200000,
    250000,
    500000,
    1000000,
  ];

  @override
  void initState() {
    super.initState();

    _tfNominal.addListener(() {
      final isBtnTopupActive =
          _tfNominal.text.isNotEmpty && _tfNominal.text.length >= 6;

      setState(() => _isBtnTopupActive = isBtnTopupActive);
    });
  }

  @override
  void dispose() {
    _tfNominal.dispose();

    super.dispose();
  }

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
          "ISI SALDO",
          style: TextStyle(
            color: Color(0xff06113D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TITLE KETIKAN NOMINAL
            SubtitleText(text: "Ketikan Nominal"),

            //TEXT FIELD KETIKAN NOMINAL
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: TextField(
                controller: _tfNominal,
                cursorHeight: 50,
                cursorColor: ColorsTheme.myOrange,
                keyboardType: TextInputType.number,
                maxLength: 9,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: ColorsTheme.myDarkBlue),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  counter: Offstage(),
                  hintText: "0",
                  icon: Text(
                    "Rp ",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.myDarkBlue),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  val = Formater.toIDR(val.replaceAll('.', ''));
                  _tfNominal.value = TextEditingValue(
                    text: val,
                    selection: TextSelection.collapsed(offset: val.length),
                  );
                },
              ),
            ),

            //TITLE KETIKAN NOMINAL ISI SALDO
            SubtitleText(text: "Pilih Nominal"),

            //WIDGET LIST PILIHAN NOMINAL ISI SALDO
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 16, bottom: 150),
              child: Wrap(
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                children: List.generate(
                  _topUpItems.length,
                  (index) => Obx(
                    () => choiceSaldo(context, index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: ColorsTheme.myOrange,
            shape: StadiumBorder(),
            minimumSize: Size(double.maxFinite, 50),
          ),
          child: Text(
            "ISI SALDO",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsTheme.myDarkBlue,
            ),
          ),
          onPressed: _isBtnTopupActive ? () => topUp() : null,
          //onPressed: _isBtnTopupActive ? () =>  Get.offAllNamed(NavBar.TAG) : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void topUp() async {
    await ApiServices.topUp(
      userID: userID!,
      nominal: _tfNominal.text.replaceAll(".", ""),
    ).then(
      (value) {
        Get.offAllNamed(NavBar.TAG);
        Get.snackbar("Berhasil", "Berhasil melakukan top up saldo");
      },
    );
  }

  GestureDetector choiceSaldo(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width / 3.6,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isSelected.value ? ColorsTheme.myOrange : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Text(
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp\n',
              decimalDigits: 0,
            ).format(_topUpItems[index]),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.bold,
              color: ColorsTheme.myDarkBlue,
            ),
          ),
        ),
      ),
      onTap: () {
        _isSelected.value = !_isSelected.value;

        var val = NumberFormat.currency(
          locale: 'id',
          symbol: '',
          decimalDigits: 0,
        ).format(_topUpItems[index]);

        _tfNominal.value = TextEditingValue(text: val);
      },
    );
  }
}
