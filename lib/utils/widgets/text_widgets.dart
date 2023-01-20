import 'package:flutter/widgets.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorsTheme.myGrey,
      ),
    );
  }
}