import 'package:flutter/material.dart';
import 'package:projetc2/models/Meal.dart';

import 'package:projetc2/models/restaurents_model.dart';
import 'package:projetc2/screens/restaurant_detail_screen.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lottie/lottie.dart';

import '../widgets/cart_widget.dart';

class CartGrid extends StatefulWidget {
  const CartGrid({Key? key}) : super(key: key);

  static Map<Meal, int> cart = Map();

  @override
  State<CartGrid> createState() => _CartGridState();
}

class _CartGridState extends State<CartGrid> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      CartGrid.cart = RestaurantDetailScreen.order.ord1.isEmpty
          ? {}
          : RestaurantDetailScreen.order.ord1;
    });

    final cartList = CartGrid.cart.values.toList();
    final cartKeys = CartGrid.cart.keys.toList();
    final RestaurantModel? restaurant =
        RestaurantDetailScreen.order.ord1.isEmpty
            ? null
            : getRestaurantById(RestaurantDetailScreen.order.idResataurent);
    //  MealModel meal = RestaurantDetailScreen.categoryModel;

    //List<Meal> meals = [];

    // for (int i = 0; i < CartGrid.cart.length; i++) {
    // Meal mea = meal.meals.firstWhere((mela) => mela.id == cartKeys[i]);
    //meals.add(mea);
    //}

    return CartGrid.cart.isEmpty
        ? SizedBox(
            height: 78.h,
            child: Center(
              child: SizedBox(
                  height: 40.h,
                  child: Lottie.asset("assets/lotties/42176-empty-cart.json")),
            ),
          )
        : SizedBox(
            height: 78.h,
            child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, i) {
                  return CartWidget(
                    menuTitle: cartKeys[i].name,
                    menuImage: cartKeys[i].image,
                    menuPrice: cartKeys[i].price * cartList[i],
                    restaurantTitle: restaurant!.name,
                    menuQuantity: cartList[i],
                    cartIncrement: () {
                      setState(() {
                        int a = RestaurantDetailScreen.order.ord1[cartKeys[i]]
                            as int;
                        a++;
                        RestaurantDetailScreen.order.ord1[cartKeys[i]] = a;
                        cartList[i] = a;
                        print(RestaurantDetailScreen.order.ord1[cartKeys[i]]);
                      });
                    },
                    cartDecrement: () {
                      setState(() {
                        int a = RestaurantDetailScreen.order.ord1[cartKeys[i]]
                            as int;
                        if (a >= 0) {
                          a--;
                          RestaurantDetailScreen.order.ord1[cartKeys[i]] = a;
                          cartList[i] = a;
                          if (cartList[i] <= 0) {
                            RestaurantDetailScreen.order.ord1
                                .remove(cartKeys[i]);
                            RestaurantDetailScreen.order.ord
                                .remove(cartKeys[i].id);
                          }
                          if (RestaurantDetailScreen.order.ord1.isEmpty) {
                            CartGrid.cart.clear();
                          }
                          print(RestaurantDetailScreen.order.ord1[cartKeys[i]]);
                        } else {
                          // RestaurantDetailScreen.order.ord.remove(cartList[i]);
                          CartGrid.cart.remove(cartKeys[i]);
                          RestaurantDetailScreen.order.ord1
                              .remove([cartKeys[i]]);
                          print(CartGrid.cart.length);
                          print(RestaurantDetailScreen.order.ord1.length);
                        }
                      });
                    },
                  );
                }),
          );
  }
}
