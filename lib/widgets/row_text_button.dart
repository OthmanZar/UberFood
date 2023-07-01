import "package:flutter/material.dart";
import 'package:projetc2/widgets/text_widget.dart';

import '../global/app_text_style.dart';
import '../models/cities.dart';

class RowTextBtn extends StatelessWidget {
  // static String city = "";
  final String text;

  final VoidCallback onPressed;
  const RowTextBtn({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextWidget(text: text, textStyle: textStyle7),
        const Spacer(),
        TextButton(
          onPressed: () {
            final selectedCity =
                ModalRoute.of(context)!.settings.arguments as City?;
            if (selectedCity != null) {
              // city = selectedCity.city;
              print(
                  'Selected City: ${selectedCity.city}'); // Print the selected city
              print(
                  'Selected City ID: ${selectedCity.id}'); // Print the selected city ID
            }
          },
          child: TextWidget(text: "", textStyle: textStyle6),
        )
      ],
    );
  }
}
