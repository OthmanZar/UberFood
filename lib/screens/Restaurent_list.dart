import 'package:flutter/material.dart';

import '../models/restaurents_model.dart';

class RestaurantListScreen extends StatelessWidget {
  static const routeName = "/Restaurant";
  @override
  Widget build(BuildContext context) {
    final restaurantId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant List')),
      body: FutureBuilder<List<RestaurantModel>>(
        future: fetchRestaurantData(restaurantId as int),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final restaurantList = snapshot.data!;
            return ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                final restaurant = restaurantList[index];
                return ListTile(
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.street),
                  leading: Image.network(restaurant.image),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
