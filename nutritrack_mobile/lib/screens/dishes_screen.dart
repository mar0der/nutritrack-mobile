import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dishes_provider.dart';
import '../models/dish.dart';

class DishesScreen extends StatefulWidget {
  const DishesScreen({super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        context.read<DishesProvider>().loadDishes();
        _isInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDishDialog(),
          ),
        ],
      ),
      body: Consumer<DishesProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return _buildErrorState(provider);
          }

          return Column(
            children: [
              _buildSearchBar(provider),
              Expanded(
                child: provider.isLoading && provider.dishes.isEmpty
                    ? _buildLoadingState()
                    : _buildDishesList(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(DishesProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    provider.clearSearch();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          provider.searchDishes(value);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading recipes...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(DishesProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                provider.loadDishes();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishesList(DishesProvider provider) {
    final dishes = provider.filteredDishes;
    
    if (dishes.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadDishes(),
      child: ListView.builder(
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return _buildDishCard(dish, provider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 80,
              color: Color(0xFF10B981),
            ),
            SizedBox(height: 20),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Create your first recipe to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishCard(Dish dish, DishesProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (dish.description != null)
                        Text(
                          dish.description!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        _showDishDetails(dish);
                        break;
                      case 'edit':
                        _showEditDishDialog(dish);
                        break;
                      case 'delete':
                        _showDeleteConfirmation(dish, provider);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility),
                          SizedBox(width: 8),
                          Text('View'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${dish.dishIngredients.length} ingredients',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 16),
                if (dish.freshnessScore != null) ...[
                  const Icon(Icons.eco, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    'Freshness: ${(dish.freshnessScore! * 100).toInt()}%',
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            _buildIngredientChips(dish),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientChips(Dish dish) {
    if (dish.dishIngredients.isEmpty) return const SizedBox.shrink();
    
    final displayIngredients = dish.dishIngredients.take(3);
    final remainingCount = dish.dishIngredients.length - 3;
    
    return Wrap(
      spacing: 4,
      children: [
        ...displayIngredients.map((dishIngredient) => Chip(
          label: Text(
            dishIngredient.ingredient.name,
            style: const TextStyle(fontSize: 10),
          ),
          backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )),
        if (remainingCount > 0)
          Chip(
            label: Text(
              '+$remainingCount more',
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: Colors.grey.withOpacity(0.1),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }

  void _showDishDetails(Dish dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dish.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dish.description != null) ...[
              Text(dish.description!),
              const SizedBox(height: 16),
            ],
            const Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...dish.dishIngredients.map((di) => Text(
              '• ${di.quantity}${di.unit} ${di.ingredient.name}',
            )),
            if (dish.instructions != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(dish.instructions!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddDishDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add recipe dialog - Coming soon!')),
    );
  }

  void _showEditDishDialog(Dish dish) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${dish.name} - Coming soon!')),
    );
  }

  void _showDeleteConfirmation(Dish dish, DishesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${dish.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await provider.deleteDish(dish.id);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${dish.name} deleted')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}