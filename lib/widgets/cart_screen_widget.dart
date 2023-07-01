import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetc2/models/object.dart';
import 'package:projetc2/models/order.dart';
import 'package:projetc2/screens/restaurant_detail_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../global/app_color.dart';
import '../models/Meal.dart';
import '../screens/map.dart';
import 'cart_grid.dart';

class CartScreenWidget extends StatefulWidget {
  const CartScreenWidget({Key? key}) : super(key: key);

  @override
  State<CartScreenWidget> createState() => _CartScreenWidgetState();
}

class _CartScreenWidgetState extends State<CartScreenWidget> {
  void clearCart() {
    setState(() {
      RestaurantDetailScreen.order = OrderModel();

      CartGrid.cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CartGrid(),
        CartGrid.cart.isEmpty
            ? Text("")
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: greenColor1,
                    minimumSize: Size(double.infinity, 8.h),
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(
                        context,
                        HomePage.routeName,
                        arguments: CartGrid.cart,
                      );

                      List<Meal> keys =
                          RestaurantDetailScreen.order.ord1.keys.toList();
                      List<int> values =
                          RestaurantDetailScreen.order.ord1.values.toList();
                      double price = 0;
                      List<ObjectModel> listObjects = [];

                      for (int i = 0; i < keys.length; i++) {
                        ObjectModel object = ObjectModel(
                          idMeal: keys[i].id,
                          qte: values[i],
                          price: keys[i].price * values[i],
                        );
                        price += keys[i].price * values[i];
                        listObjects.add(object);
                      }

                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        String email = user.email!;
                        RestaurantDetailScreen.order.email = email;
                      }

                      RestaurantDetailScreen.order.objects = listObjects;
                      RestaurantDetailScreen.order.price = price;
                    });
                  },
                  child: const Text("Confirmer la demande"),
                ),
              ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: redColor2,
              minimumSize: Size(double.infinity, 8.h),
            ),
            onPressed: () {
              clearCart();
            },
            child: const Text("vider"),
          ),
        ),
      ],
    );
  }
}
