import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../services/api_service.dart';

class IngredientsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Ingredient> _ingredients = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;

  List<Ingredient> get ingredients => _ingredients;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  List<Ingredient> get filteredIngredients {
    var filtered = _ingredients;
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered = filtered
          .where((ingredient) => ingredient.category == _selectedCategory)
          .toList();
    }
    
    return filtered;
  }

  List<String> get categories {
    final cats = _ingredients.map((i) => i.category).toSet().toList();
    cats.sort();
    return cats;
  }

  Future<void> loadIngredients() async {
    _setLoading(true);
    _clearError();
    
    try {
      _ingredients = await _apiService.getIngredients();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load ingredients: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchIngredients(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      _ingredients = await _apiService.getIngredients(search: query);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search ingredients: $e');
    } finally {
      _setLoading(false);
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  Future<bool> createIngredient({
    required String name,
    required String category,
    Map<String, dynamic>? nutritionalInfo,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newIngredient = await _apiService.createIngredient(
        name: name,
        category: category,
        nutritionalInfo: nutritionalInfo,
      );
      
      _ingredients.add(newIngredient);
      _ingredients.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create ingredient: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateIngredient(
    String id, {
    String? name,
    String? category,
    Map<String, dynamic>? nutritionalInfo,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedIngredient = await _apiService.updateIngredient(
        id,
        name: name,
        category: category,
        nutritionalInfo: nutritionalInfo,
      );
      
      final index = _ingredients.indexWhere((i) => i.id == id);
      if (index != -1) {
        _ingredients[index] = updatedIngredient;
        _ingredients.sort((a, b) => a.name.compareTo(b.name));
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update ingredient: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteIngredient(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _apiService.deleteIngredient(id);
      _ingredients.removeWhere((i) => i.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete ingredient: $e');
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