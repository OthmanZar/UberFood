import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/historique.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

final User? user = FirebaseAuth.instance.currentUser;
final String? email = user!.email;

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88.h,
      child: FutureBuilder<List<HistoriqueModel>>(
        future: fetchRestaurantData(email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final restaurantList = snapshot.data!;
            return ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                if (restaurantList[index].state == "done") {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        restaurantList[index].image,
                      ),
                    ),
                    title: Text("ID: ${restaurantList[index].id}"),
                    subtitle: Text("Prix: ${restaurantList[index].price} DH"),
                    // trailing: Text("Prix: ${restaurantList[index].price} DH"),
                  );
                } else {
                  return Container(); // Empty container if state is not "done"
                }
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
