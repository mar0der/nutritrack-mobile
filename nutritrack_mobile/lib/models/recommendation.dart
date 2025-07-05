import 'dish.dart';

class Recommendation {
  final String id;
  final String name;
  final String? description;
  final String? instructions;
  final List<DishIngredient> dishIngredients;
  final double freshnessScore;
  final int recentIngredients;
  final int totalIngredients;
  final String reason;

  Recommendation({
    required this.id,
    required this.name,
    this.description,
    this.instructions,
    required this.dishIngredients,
    required this.freshnessScore,
    required this.recentIngredients,
    required this.totalIngredients,
    required this.reason,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      instructions: json['instructions'],
      dishIngredients: (json['dishIngredients'] as List)
          .map((item) => DishIngredient.fromJson(item))
          .toList(),
      freshnessScore: json['freshnessScore']?.toDouble() ?? 0.0,
      recentIngredients: json['recentIngredients'] ?? 0,
      totalIngredients: json['totalIngredients'] ?? 0,
      reason: json['reason'] ?? '',
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