import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../global/app_color.dart';

import '../models/restaurents_model.dart';
import '../screens/restaurant_categories_screen.dart';
import 'menu_grid.dart';

class SearcherWidget extends StatefulWidget {
  const SearcherWidget({Key? key}) : super(key: key);
  static String quer = "";

  @override
  State<SearcherWidget> createState() => _SearcherWidgetState();
}

class _SearcherWidgetState extends State<SearcherWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(context: context, delegate: RestaurantSearch());
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          height: 8.h,
          decoration: BoxDecoration(
              color: const Color(0xfffef6ed),
              borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.all(10),
          child: const Row(
            children: [
              Icon(Icons.search, color: orangeColor1, size: 30),
              Text("Que voulez-vous commander?"),
            ],
          )),
    );
  }
}

class RestaurantSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
      // IconButton(
      // onPressed: () {
      // SearcherWidget.quer = query;
      //showSuggestions(context);
      //},
      //icon: const Icon(Icons.tune, color: orangeColor2),
      // )
    ];
    //throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_city, size: 120),
          const SizedBox(height: 48),
          Text(
            query,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //  final restaurant =
    //    Provider.of<Restaurants>(context).searchRestaurants(query);
    // final selectedCity = ModalRoute.of(context)!.settings.arguments as City?;
    return FutureBuilder<List<RestaurantModel>>(
      future: fetchRestaurantData(MenuGrid.city),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // final restaurantList = snapshot.data!;
          final rest = getRestaurantByQuery(query);
          if (rest.isEmpty) {
            return const Text("Aucun résultat trouvé");
          } else {
            return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: rest.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RestaurantCategoriescreen.routeName,
                          arguments: [rest[i].id, rest[i].city]);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        rest[i].image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      rest[i].name,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      rest[i].street,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text(restaurant[i].catchPhrase.toString()),
                  );
                });
          }
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
