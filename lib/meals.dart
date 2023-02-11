double _getDoubleValue(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    return 0.0;
  }
}

class Meal {
  final String? name;
  final List<dynamic>? ingredients;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbohydrates;
  final String? instructions;
  final double? sodium;
  final double? fiber;
  final Map? nutrition;
  final String? imgURL;

  Meal(
      {this.name,
        this.ingredients,
        this.calories,
        this.protein,
        this.fat,
        this.carbohydrates,
        this.instructions,
        this.sodium,
        this.fiber,
        this.nutrition,
        this.imgURL});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
        name: json['name'] as String,
        ingredients: json['ingredients'] as List<dynamic>,
        instructions: json['instructions'] as String,
        calories: _getDoubleValue(json['nutrition']['calories'] ?? json['nutrition']['Calories']),
        carbohydrates: _getDoubleValue(json['nutrition']['carbohydrates'] ?? json['nutrition']['Carbohydrates']),
        fat: _getDoubleValue(json['nutrition']['fat'] ?? json['nutrition']['Fat']),
        fiber: _getDoubleValue(json['nutrition']['fiber'] ?? json['nutrition']['Fiber']),
        protein: _getDoubleValue(json['nutrition']['protein'] ?? json['nutrition']['Protein']),
        sodium: _getDoubleValue(json['nutrition']['sodium'] ?? json['nutrition']['Sodium']),
        nutrition: json['nutrition'] as Map,
        imgURL: json['imgURL'] ?? 'https://cdn.pixabay.com/photo/2015/10/26/07/21/vegetables-1006694_960_720.jpg' as String);
  }

  String get id => name!.toLowerCase().replaceAll(' ', '_');

}
