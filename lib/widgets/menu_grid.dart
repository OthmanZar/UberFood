import 'package:flutter/material.dart';

import 'package:projetc2/widgets/restaurant_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/cities.dart';

import '../models/restaurents_model.dart';

class MenuGrid extends StatelessWidget {
  //final List<Restaurant> menu;
  // const MenuGrid({Key? key, required this.menu}) : super(key: key);
  static int city = 0;
  @override
  Widget build(BuildContext context) {
    final selectedCity = ModalRoute.of(context)!.settings.arguments as City?;
    city = selectedCity!.id;
    return SizedBox(
        height: 68.h,
        child: FutureBuilder<List<RestaurantModel>>(
          future: fetchRestaurantData(selectedCity.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final restaurantList = snapshot.data!;
              return ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];
                  return RestaurantWidget(restaurant: restaurant);
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
