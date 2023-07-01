import 'package:projetc2/models/Meal.dart';
import 'package:projetc2/models/object.dart';

class OrderModel {
  int restcity = 0;
  String email = "";
  int idResataurent = 0;
  double lang = 0;
  double lat = 0;
  int idCity = 0;
  int idUser = 0;
  int idCategory = 0;
  Map<int, int> ord = Map();
  Map<Meal, int> ord1 = Map();

  List<ObjectModel> objects = [];
  double price = 0;
  List<MealModel> meal = [];
}
//String email , int idRestCity , double lang , double lat , list of objects (idMeal , qte , price)