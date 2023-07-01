import 'package:flutter/material.dart';
import 'package:projetc2/models/cities.dart';
import 'package:projetc2/screens/restaurant_categories_screen.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/restaurents_model.dart';

class RestaurantWidget extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantWidget({Key? key, required this.restaurant})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      //  margin: EdgeInsets.all(1.h),
      height: 28.h,
      width: 45.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onTap: () {
          final City? citySel =
              ModalRoute.of(context)!.settings.arguments as City?;

          Navigator.pushNamed(context, RestaurantCategoriescreen.routeName,
              arguments: [restaurant.id, citySel!.id]);
        },
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              SizedBox(
                  height: 18.h,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          // topLeft: Radius.circular(20),
                          // topRight: Radius.circular(20)
                          20),
                      child: Image.network(
                        restaurant.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              SizedBox(height: 1.h),
              FittedBox(
                child: Text(
                  restaurant.name,
                  style:
                      TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "${restaurant.street}",
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
