import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoriqueModel {
  final int id;
  final String email;
  final double price;
  final String image;
  final String state;
  HistoriqueModel({
    required this.id,
    required this.email,
    required this.price,
    required this.image,
    required this.state,
  });
}

List<HistoriqueModel> restaurantList = [];

Future<List<HistoriqueModel>> fetchRestaurantData(String email) async {
  restaurantList.clear();
  final response =
      await http.get(Uri.parse('http://192.168.0.165:8800/order/$email'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body) as List<dynamic>;

    for (var data in jsonData) {
      final idrestCity = data['id'];
      final restaurantData = data['cityRests'];
      final restaurent = restaurantData['restaurent'];
      final restaurantId = restaurent['id'];
      final stat = data['state'];
      final price = data['price'];

      final restaurant = HistoriqueModel(
        id: idrestCity,
        image: 'http://192.168.0.165:8800/photoRestaurent/$restaurantId',
        email: email,
        price: price,
        state: stat,
      );
      restaurantList.add(restaurant);
    }

    return restaurantList;
  } else {
    throw Exception('Failed to fetch restaurant data');
  }
}
