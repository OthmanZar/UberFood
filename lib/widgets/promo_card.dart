import 'package:flutter/cupertino.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../global/app_color.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: greenColor2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          "assets/images/Promo Advertising.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
