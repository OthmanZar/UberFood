import 'dart:convert';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CategoryModel {
  List<Category> categories = [];
  Future<void> fetchCategoriesData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.165:8800/categories'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      categories = jsonData.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch categories data');
    }
  }

  Category getCategoryById(int categoryId) {
    return categories.firstWhere((category) => category.id == categoryId);
  }
}
