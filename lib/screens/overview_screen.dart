import 'package:flutter/material.dart';
import 'package:projetc2/screens/profile_screen.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/cart_screen_widget.dart';
import '../widgets/favourites_screen.dart';

import 'home_screen.dart';
import 'message_screen.dart';

class OverViewScreenScreen extends StatefulWidget {
  const OverViewScreenScreen({Key? key}) : super(key: key);

  static const routeName = "/overViewScreen";

  @override
  State<OverViewScreenScreen> createState() => _OverViewScreenScreenState();
}

class _OverViewScreenScreenState extends State<OverViewScreenScreen> {
  int _currentIndex = 0;

  final List _screens = const [
    HomeScreen(),
    FavouritesScreen(),
    CartScreenWidget(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final topSpace = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: topSpace),
            _screens[_currentIndex],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        //    routeName: "",
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index), routeName: '',
      ),
    );
  }
}
