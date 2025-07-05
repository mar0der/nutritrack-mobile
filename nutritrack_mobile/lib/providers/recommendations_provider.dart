import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import '../services/api_service.dart';

class RecommendationsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  String? _error;
  int _avoidanceDays = 7;
  int _limit = 10;

  List<Recommendation> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get avoidanceDays => _avoidanceDays;
  int get limit => _limit;

  // Get top recommendation
  Recommendation? get topRecommendation {
    if (_recommendations.isEmpty) return null;
    return _recommendations.first;
  }

  // Get alternative recommendations (excluding the top one)
  List<Recommendation> get alternativeRecommendations {
    if (_recommendations.length <= 1) return [];
    return _recommendations.skip(1).toList();
  }

  // Group recommendations by freshness score
  Map<String, List<Recommendation>> get groupedByFreshness {
    final Map<String, List<Recommendation>> grouped = {
      'Perfect Match': [],
      'Great Options': [],
      'Good Choices': [],
    };

    for (final rec in _recommendations) {
      if (rec.freshnessScore >= 0.9) {
        grouped['Perfect Match']!.add(rec);
      } else if (rec.freshnessScore >= 0.7) {
        grouped['Great Options']!.add(rec);
      } else {
        grouped['Good Choices']!.add(rec);
      }
    }

    return grouped;
  }

  Future<void> loadRecommendations() async {
    _setLoading(true);
    _clearError();
    
    try {
      _recommendations = await _apiService.getRecommendations(
        days: _avoidanceDays,
        limit: _limit,
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to load recommendations: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshRecommendations() async {
    await loadRecommendations();
  }

  void updateSettings({int? avoidanceDays, int? limit}) {
    bool shouldRefresh = false;
    
    if (avoidanceDays != null && avoidanceDays != _avoidanceDays) {
      _avoidanceDays = avoidanceDays;
      shouldRefresh = true;
    }
    
    if (limit != null && limit != _limit) {
      _limit = limit;
      shouldRefresh = true;
    }
    
    if (shouldRefresh) {
      notifyListeners();
      loadRecommendations();
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