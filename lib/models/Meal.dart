import 'dart:convert';
import 'package:http/http.dart' as http;

class Meal {
  final int id;
  final String name;
  final double price;
  final int restaurantId;
  final int categoryId;
  String image;
  final String? description;

  Meal({
    required this.id,
    required this.name,
    required this.price,
    required this.restaurantId,
    required this.categoryId,
    required this.image,
    this.description,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      restaurantId: json['restaurent']['id'],
      categoryId: json['category']['id'],
      image: json[
          'image'], // Assuming the image URL is provided in the API response
      description: json['description'],
    );
  }
}

class MealModel {
  List<Meal> meals = [];

  Future<void> fetchMealsData(int restaurantId, int categoryId) async {
    final url =
        'http://192.168.0.165:8800/meals?restaurent=$restaurantId&category=$categoryId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      meals = jsonData.map((data) => Meal.fromJson(data)).toList();

      // Fetch images for each meal
      await fetchMealImages();
    } else {
      throw Exception('Failed to fetch meals data');
    }
  }

  Future<void> fetchMealImages() async {
    for (var meal in meals) {
      final imageUrl = 'http://192.168.0.165:8800/photo/meal/${meal.id}';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Assuming the API returns the image in the response body
        meal.image = 'http://192.168.0.165:8800/photo/meal/${meal.id}';
      } else {
        // Set a default image or handle the error case
        meal.image = ''; // Replace with the default image URL or null
      }
    }
  }
}
