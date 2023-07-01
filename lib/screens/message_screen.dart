import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/historique.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);
  static const routeName = "/message";

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

final User? user = FirebaseAuth.instance.currentUser;
final String? email = user!.email;

class _MessageScreenState extends State<MessageScreen> {
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
                if (restaurantList[index].state == "coocking") {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        restaurantList[index].image,
                      ),
                    ),
                    title: Text("ID: ${restaurantList[index].id}"),
                    subtitle: Text("Prix: ${restaurantList[index].price} DH"),
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
    //    bottomNavigationBar: BottomNavBar(currentIndex: 2, routeName: routeName),
  }
}
