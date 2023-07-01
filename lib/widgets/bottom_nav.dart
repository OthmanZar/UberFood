import 'package:flutter/material.dart';
import 'package:projetc2/screens/restaurant_detail_screen.dart';

import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../global/app_color.dart';
import '../provider/cart.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavBar(
      {Key? key,
      required this.currentIndex,
      required this.onTap,
      required String routeName})
      : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavyBar(
          containerHeight: 8.h,
          selectedIndex: widget.currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          onItemSelected: widget.onTap,
          curve: Curves.easeIn,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Accueil'),
              activeColor: greenColor1,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
                icon: const Icon(Icons.history),
                title: const Text("Historique"),
                activeColor: Colors.red,
                textAlign: TextAlign.center),
            BottomNavyBarItem(
              icon: Consumer<Cart>(
                builder: (BuildContext context, cart, Widget? child) {
                  return Badge(
                    label: Text(
                        RestaurantDetailScreen.order.ord1.length.toString()),
                    textColor: greenColor1,
                    child: const Icon(
                      Icons.shopping_cart,
                      size: 30,
                    ),
                  );
                },
              ),
              title: const Text(
                'Panier',
              ),
              activeColor: Colors.pink,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.notifications),
              title: const Text('Orders'),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
