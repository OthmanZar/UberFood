import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global/app_color.dart';
import '../widgets/menu_grid.dart';

import '../widgets/row_text_button.dart';
import '../widgets/search_widget.dart';
import '../widgets/space_widget.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter?'),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  AuthScreen.routeName,
                  (Route<dynamic> route) => false,
                  arguments: 0,
                );
              },
              child: const Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('anuller'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final restauruant = Provider.of<Restaurants>(context);
    // final restaurants = restauruant.restaurants;

    //final menus = restauruant.menu;
    return /*Scaffold(
      persistentFooterButtons: const [BottomVBar(pageNum: 1)],
      body:*/
        SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: const SearcherWidget(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: _showVerificationDialog,
                    icon: const Icon(Icons.logout, size: 35),
                    color: orangeColor1,
                  ),
                ),
              ],
            ),
            const SpaceWidget(),
            // const PromoCard(),
            const SpaceWidget(),
            RowTextBtn(
              text: " Nos Restaurants",
              onPressed: () {},
            ),
            const SpaceWidget(),
            // RestaurantGrid(restaurants: restaurants),
            const SpaceWidget(),
            // RowTextBtn(text: "Popular Menus", onPressed: () {}),
            // const SpaceWidget(),
            MenuGrid()
          ],
        ),
      ),
    ); /*,
      // bottomNavigationBar: const BottomNavBar(
      //   currentIndex: 1,
      //   routeName: routeName,
      // ),
    );*/
  }
}
