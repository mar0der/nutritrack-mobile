import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../services/api_service.dart';

class DishesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Dish> _dishes = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Dish> get dishes => _dishes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<Dish> get filteredDishes {
    if (_searchQuery.isEmpty) return _dishes;
    
    return _dishes
        .where((dish) =>
            dish.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (dish.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
        .toList();
  }

  Future<void> loadDishes() async {
    _setLoading(true);
    _clearError();
    
    try {
      _dishes = await _apiService.getDishes();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load dishes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchDishes(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      _dishes = await _apiService.getDishes(search: query);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search dishes: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<Dish?> getDish(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final dish = await _apiService.getDish(id);
      return dish;
    } catch (e) {
      _setError('Failed to load dish: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createDish({
    required String name,
    String? description,
    String? instructions,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newDish = await _apiService.createDish(
        name: name,
        description: description,
        instructions: instructions,
        ingredients: ingredients,
      );
      
      _dishes.add(newDish);
      _dishes.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create dish: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateDish(
    String id, {
    String? name,
    String? description,
    String? instructions,
    List<Map<String, dynamic>>? ingredients,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedDish = await _apiService.updateDish(
        id,
        name: name,
        description: description,
        instructions: instructions,
        ingredients: ingredients,
      );
      
      final index = _dishes.indexWhere((d) => d.id == id);
      if (index != -1) {
        _dishes[index] = updatedDish;
        _dishes.sort((a, b) => a.name.compareTo(b.name));
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update dish: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteDish(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _apiService.deleteDish(id);
      _dishes.removeWhere((d) => d.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete dish: $e');
      return false;
    } finally {
      _setLoading(false);
    }
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