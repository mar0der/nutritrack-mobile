import 'ingredient.dart';

class DishIngredient {
  final String ingredientId;
  final double quantity;
  final String unit;
  final Ingredient ingredient;

  DishIngredient({
    required this.ingredientId,
    required this.quantity,
    required this.unit,
    required this.ingredient,
  });

  factory DishIngredient.fromJson(Map<String, dynamic> json) {
    return DishIngredient(
      ingredientId: json['ingredientId'],
      quantity: json['quantity']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      ingredient: Ingredient.fromJson(json['ingredient']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'quantity': quantity,
      'unit': unit,
      'ingredient': ingredient.toJson(),
    };
  }
}

class Dish {
  final String id;
  final String name;
  final String? description;
  final String? instructions;
  final List<DishIngredient> dishIngredients;
  final double? freshnessScore;
  final int? recentIngredients;
  final int? totalIngredients;
  final String? reason;

  Dish({
    required this.id,
    required this.name,
    this.description,
    this.instructions,
    required this.dishIngredients,
    this.freshnessScore,
    this.recentIngredients,
    this.totalIngredients,
    this.reason,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      instructions: json['instructions'],
      dishIngredients: (json['dishIngredients'] as List)
          .map((item) => DishIngredient.fromJson(item))
          .toList(),
      freshnessScore: json['freshnessScore']?.toDouble(),
      recentIngredients: json['recentIngredients'],
      totalIngredients: json['totalIngredients'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'dishIngredients': dishIngredients.map((item) => item.toJson()).toList(),
      'freshnessScore': freshnessScore,
      'recentIngredients': recentIngredients,
      'totalIngredients': totalIngredients,
      'reason': reason,
    };
  }
}