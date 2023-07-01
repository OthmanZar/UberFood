import 'object.dart';

class OrderFinal {
  final String email;
  final List<ObjectModel> items;
  final int restaurentCity;
  final double latitude;
  final double longitude;
  final double price;

  OrderFinal({
    required this.email,
    required this.items,
    required this.restaurentCity,
    required this.latitude,
    required this.longitude,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      "items": items.map((item) => item.toJson()).toList(),
      "restaurentCity": restaurentCity,
      "latitude": latitude,
      "longitude": longitude,
      "price": price
    };
  }
}
