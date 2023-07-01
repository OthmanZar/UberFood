class ObjectModel {
  int idMeal = 0;
  int qte = 0;
  double price = 0;

  ObjectModel({required this.idMeal, required this.qte, required this.price});

  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'qte': qte,
      'price': price,
    };
  }
}
