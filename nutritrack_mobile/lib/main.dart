import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_router.dart';
import 'providers/ingredients_provider.dart';
import 'providers/dishes_provider.dart';
import 'providers/consumption_provider.dart';
import 'providers/recommendations_provider.dart';

void main() {
  runApp(const NutriTrackApp());
}

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IngredientsProvider()),
        ChangeNotifierProvider(create: (_) => DishesProvider()),
        ChangeNotifierProvider(create: (_) => ConsumptionProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationsProvider()),
      ],
      child: MaterialApp.router(
        title: 'NutriTrack',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3B82F6),
            primary: const Color(0xFF3B82F6),
            secondary: const Color(0xFF10B981),
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
