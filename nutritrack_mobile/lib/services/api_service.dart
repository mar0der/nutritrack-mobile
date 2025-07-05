import 'package:dio/dio.dart';
import '../models/ingredient.dart';
import '../models/dish.dart';
import '../models/consumption_log.dart';
import '../models/recommendation.dart';

class ApiService {
  // Use Mac IP for physical device, localhost for simulator
  static const String baseUrl = 'http://192.168.1.110:3001/api';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Ingredients
  Future<List<Ingredient>> getIngredients({String? search, String? category}) async {
    try {
      final response = await _dio.get('/ingredients', queryParameters: {
        if (search != null) 'search': search,
        if (category != null) 'category': category,
      });
      return (response.data as List)
          .map((item) => Ingredient.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch ingredients: $e');
    }
  }

  Future<Ingredient> getIngredient(String id) async {
    try {
      final response = await _dio.get('/ingredients/$id');
      return Ingredient.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch ingredient: $e');
    }
  }

  Future<Ingredient> createIngredient({
    required String name,
    required String category,
    Map<String, dynamic>? nutritionalInfo,
  }) async {
    try {
      final response = await _dio.post('/ingredients', data: {
        'name': name,
        'category': category,
        if (nutritionalInfo != null) 'nutritionalInfo': nutritionalInfo,
      });
      return Ingredient.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create ingredient: $e');
    }
  }

  Future<Ingredient> updateIngredient(
    String id, {
    String? name,
    String? category,
    Map<String, dynamic>? nutritionalInfo,
  }) async {
    try {
      final response = await _dio.put('/ingredients/$id', data: {
        if (name != null) 'name': name,
        if (category != null) 'category': category,
        if (nutritionalInfo != null) 'nutritionalInfo': nutritionalInfo,
      });
      return Ingredient.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update ingredient: $e');
    }
  }

  Future<void> deleteIngredient(String id) async {
    try {
      await _dio.delete('/ingredients/$id');
    } catch (e) {
      throw Exception('Failed to delete ingredient: $e');
    }
  }

  // Dishes
  Future<List<Dish>> getDishes({String? search}) async {
    try {
      final response = await _dio.get('/dishes', queryParameters: {
        if (search != null) 'search': search,
      });
      return (response.data as List)
          .map((item) => Dish.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch dishes: $e');
    }
  }

  Future<Dish> getDish(String id) async {
    try {
      final response = await _dio.get('/dishes/$id');
      return Dish.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch dish: $e');
    }
  }

  Future<Dish> createDish({
    required String name,
    String? description,
    String? instructions,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    try {
      final response = await _dio.post('/dishes', data: {
        'name': name,
        if (description != null) 'description': description,
        if (instructions != null) 'instructions': instructions,
        'ingredients': ingredients,
      });
      return Dish.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create dish: $e');
    }
  }

  Future<Dish> updateDish(
    String id, {
    String? name,
    String? description,
    String? instructions,
    List<Map<String, dynamic>>? ingredients,
  }) async {
    try {
      final response = await _dio.put('/dishes/$id', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (instructions != null) 'instructions': instructions,
        if (ingredients != null) 'ingredients': ingredients,
      });
      return Dish.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update dish: $e');
    }
  }

  Future<void> deleteDish(String id) async {
    try {
      await _dio.delete('/dishes/$id');
    } catch (e) {
      throw Exception('Failed to delete dish: $e');
    }
  }

  // Consumption
  Future<List<ConsumptionLog>> getConsumptionLogs({int days = 30}) async {
    try {
      final response = await _dio.get('/consumption', queryParameters: {
        'days': days,
      });
      return (response.data as List)
          .map((item) => ConsumptionLog.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch consumption logs: $e');
    }
  }

  Future<ConsumptionLog> logConsumption(CreateConsumptionLogRequest request) async {
    try {
      final response = await _dio.post('/consumption', data: request.toJson());
      return ConsumptionLog.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to log consumption: $e');
    }
  }

  Future<List<String>> getRecentIngredients({int days = 7}) async {
    try {
      final response = await _dio.get('/consumption/recent-ingredients', queryParameters: {
        'days': days,
      });
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to fetch recent ingredients: $e');
    }
  }

  // Recommendations
  Future<List<Recommendation>> getRecommendations({int days = 7, int limit = 10}) async {
    try {
      final response = await _dio.get('/recommendations', queryParameters: {
        'days': days,
        'limit': limit,
      });
      return (response.data as List)
          .map((item) => Recommendation.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recommendations: $e');
    }
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('http://192.168.1.110:3001/');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}