import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantModel {
  final int id;
  final int idrestCity;
  final String name;
  final String image;
  final String street;
  final int city;
  RestaurantModel({
    required this.id,
    required this.idrestCity,
    required this.name,
    required this.image,
    required this.street,
    required this.city,
  });
}

List<RestaurantModel> restaurantList = [];

Future<List<RestaurantModel>> fetchRestaurantData(int id) async {
  restaurantList.clear();
  final response = await http
      .get(Uri.parse('http://192.168.0.165:8800/city/$id/restaurent'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body) as List<dynamic>;

    for (var data in jsonData) {
      final idrestCity = data['id'];
      final restaurantData = data['restaurent'];
      final restaurantId = restaurantData['id'];

      final restaurantName = restaurantData['name'];

      final restaurant = RestaurantModel(
          name: restaurantName,
          image: 'http://192.168.0.165:8800/photoRestaurent/$restaurantId',
          street: data['street'],
          id: restaurantId,
          idrestCity: idrestCity,
          city: id);
      restaurantList.add(restaurant);
    }

    return restaurantList;
  } else {
    throw Exception('Failed to fetch restaurant data');
  }
}

RestaurantModel getRestaurantById(int id) {
  final restaurant =
      restaurantList.firstWhere((restaurant) => restaurant.id == id);
  return restaurant;
}

List<RestaurantModel> getRestaurantByQuery(String query) {
  final restaurant = restaurantList
      .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
  return restaurant;
}
