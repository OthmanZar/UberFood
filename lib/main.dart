import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:projetc2/screens/Restaurent_list.dart';
import 'package:projetc2/screens/city_selection_screen.dart';
import 'package:projetc2/screens/map.dart';

import 'package:projetc2/screens/restaurant_categories_screen.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import './global/app_color.dart';

import './models/restaurant.dart';
import './provider/cart.dart';
import './provider/auth_provider.dart';
import './screens/overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import "./screens/on_boarding_1.dart";
import './screens/on_boarding_2.dart';

import './screens/profile_photo_screen.dart';
import './screens/signup_success_screen.dart';
import './screens/message_screen.dart';
import './screens/profile_screen.dart';
import './screens/menu_detail_screen.dart';
import './screens/restaurant_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Cart>(create: (context) => Cart()),
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<Restaurants>(
            create: ((context) => Restaurants())),
      ],
      builder: (context, child) {
        return ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Masmas Food Delivery',
              theme: lightTheme,
              darkTheme: darkTheme,
              home: const AuthScreen(),
              routes: {
                OnBoarding1.routeName: (context) => const OnBoarding1(),
                OnBoarding2.routeName: (context) => OnBoarding2(),
                AuthScreen.routeName: (context) => const AuthScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                OverViewScreenScreen.routeName: (context) =>
                    const OverViewScreenScreen(),
                ProfilePhoto.routeName: (ctx) => const ProfilePhoto(),
                SignUpSuccess.routeName: ((context) => const SignUpSuccess()),
                MenuDetailScreen.routeName: ((context) =>
                    const MenuDetailScreen()),
                ProfileScreen.routeName: (context) => const ProfileScreen(),
                MessageScreen.routeName: ((context) => const MessageScreen()),
                RestaurantCategoriescreen.routeName: (context) =>
                    const RestaurantCategoriescreen(),
                RestaurantDetailScreen.routeName: (context) =>
                    const RestaurantDetailScreen(),
                CitySelectionScreen.routeName: (context) =>
                    const CitySelectionScreen(),
                RestaurantListScreen.routeName: (context) =>
                    RestaurantListScreen(),
                HomePage.routeName: (context) => HomePage(),
              },
            );
          },
        );
      },
    );
  }
}
