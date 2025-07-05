import 'ingredient.dart';
import 'dish.dart';

class ConsumptionLog {
  final String id;
  final DateTime consumedAt;
  final double quantity;
  final String unit;
  final String? ingredientId;
  final String? dishId;
  final Ingredient? ingredient;
  final Dish? dish;

  ConsumptionLog({
    required this.id,
    required this.consumedAt,
    required this.quantity,
    required this.unit,
    this.ingredientId,
    this.dishId,
    this.ingredient,
    this.dish,
  });

  factory ConsumptionLog.fromJson(Map<String, dynamic> json) {
    return ConsumptionLog(
      id: json['id'],
      consumedAt: DateTime.parse(json['consumedAt']),
      quantity: json['quantity']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      ingredientId: json['ingredientId'],
      dishId: json['dishId'],
      ingredient: json['ingredient'] != null 
          ? Ingredient.fromJson(json['ingredient'])
          : null,
      dish: json['dish'] != null 
          ? Dish.fromJson(json['dish'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consumedAt': consumedAt.toIso8601String(),
      'quantity': quantity,
      'unit': unit,
      'ingredientId': ingredientId,
      'dishId': dishId,
      'ingredient': ingredient?.toJson(),
      'dish': dish?.toJson(),
    };
  }
}

class CreateConsumptionLogRequest {
  final String? ingredientId;
  final String? dishId;
  final double quantity;
  final String unit;
  final DateTime? consumedAt;

  CreateConsumptionLogRequest({
    this.ingredientId,
    this.dishId,
    required this.quantity,
    required this.unit,
    this.consumedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (ingredientId != null) 'ingredientId': ingredientId,
      if (dishId != null) 'dishId': dishId,
      'quantity': quantity,
      'unit': unit,
      if (consumedAt != null) 'consumedAt': consumedAt!.toIso8601String(),
    };
  }
}