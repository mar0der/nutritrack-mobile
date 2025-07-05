# NutriTrack Mobile

A Flutter-based iOS mobile application for nutrition tracking that promotes dietary variety by tracking ingredients and providing smart dish recommendations.

## Overview

NutriTrack Mobile is the iOS companion app for the NutriTrack nutrition tracking system. The app focuses on promoting dietary variety rather than just calorie counting, by tracking individual ingredient consumption and recommending dishes with ingredients that haven't been consumed recently.

## Features

- **Ingredient Tracking**: Log consumption of individual ingredients with quantities and timestamps
- **Dish Management**: Create and manage recipes with multiple ingredients
- **Smart Recommendations**: Get dish suggestions based on ingredient freshness (recency of consumption)
- **Consumption History**: View detailed logs of past meals and ingredients
- **Offline Support**: Cache data locally for basic functionality without internet

## Architecture

### Core Components
- **Home Screen**: Dashboard with daily summary and quick actions
- **Ingredients Screen**: Ingredient management and search functionality
- **Dishes Screen**: Recipe collection with freshness indicators
- **Track Screen**: Consumption logging interface
- **Recommendations Screen**: Smart dish suggestions

### Technology Stack
- **Framework**: Flutter (iOS-focused)
- **State Management**: Provider/Riverpod
- **HTTP Client**: Dio
- **Local Storage**: Hive/SQLite
- **Navigation**: GoRouter
- **UI**: Material Design 3 with custom theming

## Backend Integration

The mobile app connects to the NutriTrack REST API:
- **Base URL**: `http://localhost:3001` (development)
- **Health Check**: `http://localhost:3001/`

### Key API Endpoints
- `/api/consumption` - Consumption logging and tracking
- `/api/dishes` - Recipe/dish management
- `/api/ingredients` - Ingredient management
- `/api/recommendations` - Smart dish recommendations

## Development Setup

### Prerequisites
- **Flutter SDK** 3.16.5+
- **Xcode** (for iOS development)
- **CocoaPods** (for iOS dependencies)
- **VS Code** with Flutter extension

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/mar0der/nutritrack-mobile.git
   cd nutritrack-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   cd ios && pod install && cd ..
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands
```bash
# Check development environment
flutter doctor

# Run tests
flutter test

# Build for iOS
flutter build ios

# Run on specific device
flutter run -d [device-id]
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── services/                 # API and local storage services
├── screens/                  # UI screens
├── widgets/                  # Reusable UI components
├── providers/               # State management
└── utils/                   # Utility functions and constants
```

## Key Business Logic

### Dietary Variety Tracking
- Tracks individual ingredient consumption over time
- Calculates "freshness scores" for dishes based on ingredient recency
- Recommends dishes with ingredients not consumed recently
- Default avoidance period: 7 days

### Recommendation Algorithm
- Prioritizes dishes with ingredients not recently consumed
- Considers dietary restrictions and preferences
- Provides explanations for recommendations
- Updates in real-time based on consumption logs

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Related Projects

- **NutriTrack Backend**: Node.js/Express API server
- **NutriTrack Web**: React web application

## License

This project is part of the NutriTrack ecosystem for promoting healthy dietary variety.