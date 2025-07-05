import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/ingredients_screen.dart';
import '../screens/dishes_screen.dart';
import '../screens/track_screen.dart';
import '../screens/recommendations_screen.dart';
import '../widgets/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/ingredients',
          builder: (context, state) => const IngredientsScreen(),
        ),
        GoRoute(
          path: '/dishes',
          builder: (context, state) => const DishesScreen(),
        ),
        GoRoute(
          path: '/track',
          builder: (context, state) => const TrackScreen(),
        ),
        GoRoute(
          path: '/recommendations',
          builder: (context, state) => const RecommendationsScreen(),
        ),
      ],
    ),
  ],
);