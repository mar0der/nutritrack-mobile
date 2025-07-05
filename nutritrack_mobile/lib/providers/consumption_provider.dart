import 'package:flutter/material.dart';
import '../models/consumption_log.dart';
import '../services/api_service.dart';

class ConsumptionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ConsumptionLog> _consumptionLogs = [];
  List<String> _recentIngredients = [];
  bool _isLoading = false;
  String? _error;

  List<ConsumptionLog> get consumptionLogs => _consumptionLogs;
  List<String> get recentIngredients => _recentIngredients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get logs for a specific date
  List<ConsumptionLog> getLogsForDate(DateTime date) {
    return _consumptionLogs.where((log) {
      return log.consumedAt.year == date.year &&
          log.consumedAt.month == date.month &&
          log.consumedAt.day == date.day;
    }).toList();
  }

  // Get today's logs
  List<ConsumptionLog> get todaysLogs {
    return getLogsForDate(DateTime.now());
  }

  // Get logs grouped by meal time
  Map<String, List<ConsumptionLog>> getTodaysLogsByMeal() {
    final today = todaysLogs;
    final Map<String, List<ConsumptionLog>> grouped = {
      'Breakfast': [],
      'Lunch': [],
      'Dinner': [],
      'Snacks': [],
    };

    for (final log in today) {
      final hour = log.consumedAt.hour;
      if (hour >= 5 && hour < 11) {
        grouped['Breakfast']!.add(log);
      } else if (hour >= 11 && hour < 16) {
        grouped['Lunch']!.add(log);
      } else if (hour >= 16 && hour < 22) {
        grouped['Dinner']!.add(log);
      } else {
        grouped['Snacks']!.add(log);
      }
    }

    return grouped;
  }

  // Calculate variety score for today
  double get todaysVarietyScore {
    final uniqueIngredients = <String>{};
    for (final log in todaysLogs) {
      if (log.ingredient != null) {
        uniqueIngredients.add(log.ingredient!.id);
      } else if (log.dish != null) {
        for (final dishIngredient in log.dish!.dishIngredients) {
          uniqueIngredients.add(dishIngredient.ingredient.id);
        }
      }
    }
    
    // Simple scoring: aim for 12 different ingredients per day
    const targetIngredients = 12;
    return (uniqueIngredients.length / targetIngredients).clamp(0.0, 1.0);
  }

  Future<void> loadConsumptionLogs({int days = 30}) async {
    _setLoading(true);
    _clearError();
    
    try {
      _consumptionLogs = await _apiService.getConsumptionLogs(days: days);
      _consumptionLogs.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load consumption logs: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadRecentIngredients({int days = 7}) async {
    try {
      _recentIngredients = await _apiService.getRecentIngredients(days: days);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load recent ingredients: $e');
    }
  }

  Future<bool> logConsumption({
    String? ingredientId,
    String? dishId,
    required double quantity,
    required String unit,
    DateTime? consumedAt,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = CreateConsumptionLogRequest(
        ingredientId: ingredientId,
        dishId: dishId,
        quantity: quantity,
        unit: unit,
        consumedAt: consumedAt ?? DateTime.now(),
      );
      
      final newLog = await _apiService.logConsumption(request);
      
      _consumptionLogs.insert(0, newLog);
      _consumptionLogs.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
      
      // Refresh recent ingredients
      await loadRecentIngredients();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to log consumption: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> logIngredientConsumption({
    required String ingredientId,
    required double quantity,
    required String unit,
    DateTime? consumedAt,
  }) async {
    return logConsumption(
      ingredientId: ingredientId,
      quantity: quantity,
      unit: unit,
      consumedAt: consumedAt,
    );
  }

  Future<bool> logDishConsumption({
    required String dishId,
    required double quantity,
    required String unit,
    DateTime? consumedAt,
  }) async {
    return logConsumption(
      dishId: dishId,
      quantity: quantity,
      unit: unit,
      consumedAt: consumedAt,
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}