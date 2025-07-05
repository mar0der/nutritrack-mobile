# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NutriTrack is a mobile nutrition tracking application designed to promote dietary variety by tracking ingredients and providing smart dish recommendations. The project consists of:

- **Mobile App**: Flutter-based iOS app (starting iOS-only)
- **Backend API**: http://localhost:3001
- **Health Check**: http://localhost:3001/
- **Database**: Prisma ORM for data management

## Development Setup

### iOS Development Requirements ✅
Your environment is now set up with:
- ✅ Xcode Beta 26.0 (installed)
- ✅ Flutter SDK 3.16.5 (installed at `/Users/petarpetkov/Developer/flutter`)
- ✅ CocoaPods 1.16.2 (installed via Homebrew)
- ✅ iOS Simulator available
- ✅ VS Code with Flutter support

### Setup Commands
```bash
# Flutter is available at full path (alias created)
/Users/petarpetkov/Developer/flutter/bin/flutter --version

# Or use the alias
flutter --version

# Verify iOS development setup
flutter doctor

# Create new Flutter project (when starting)
flutter create nutritrack_mobile

# Navigate to iOS folder and install dependencies
cd ios
pod install

# Run on iOS simulator
flutter run
```

### Development Environment Status
- **Flutter**: ✅ Ready (3.16.5, PATH fixed via symlinks)
- **Dart**: ✅ Ready (3.2.3, PATH fixed via symlinks)
- **Xcode**: ✅ Ready (Beta 26.0 with iOS development tools)
- **CocoaPods**: ✅ Ready (1.16.2 via Homebrew)
- **Android**: ❌ Not needed (iOS-only development)
- **VS Code**: ✅ Ready with Flutter extension

### Setup Completed ✅
1. **Flutter SDK Installation**: Downloaded and installed Flutter 3.16.5
2. **PATH Configuration**: Fixed PATH issues by creating symlinks in `/opt/homebrew/bin/`
3. **CocoaPods Installation**: Installed via Homebrew (resolved Ruby version conflicts)
4. **Xcode Configuration**: Set Xcode Beta 26.0 as active developer directory
5. **Environment Verification**: All iOS development tools verified via `flutter doctor`

### Commands Working ✅
```bash
# All these commands now work from any directory:
flutter --version
dart --version
flutter doctor
flutter create [project_name]
flutter run
pod --version
```

### What's Left To Do
1. **Create Flutter Project**: `flutter create nutritrack_mobile` 
2. **Project Structure Setup**: Organize according to planned architecture
3. **API Integration**: Connect to backend at http://localhost:3001
4. **UI Implementation**: Build the 5 main screens (Home, Ingredients, Dishes, Track, Recommendations)
5. **State Management**: Implement Provider/Riverpod for app state
6. **Local Storage**: Add Hive/SQLite for offline support
7. **Testing**: Unit, widget, and integration tests

### Next Development Steps
1. Create new Flutter project with proper package name
2. Set up project dependencies (dio, provider, hive, etc.)
3. Implement API service layer for backend communication
4. Create basic navigation structure with bottom navigation
5. Build core data models matching API responses
6. Implement basic screens with placeholder UI

## Architecture

### Backend API Structure
The backend provides a RESTful API with the following main endpoints:
- `/api/consumption` - Consumption logging and tracking
- `/api/dishes` - Recipe/dish management
- `/api/ingredients` - Ingredient management  
- `/api/recommendations` - Smart dish recommendations based on consumption history

### Core Data Models
- **Ingredients**: Basic food items with nutritional information and categories
- **Dishes**: Recipes composed of multiple ingredients with quantities
- **Consumption Logs**: Records of when ingredients/dishes were consumed
- **Recommendations**: Smart suggestions based on ingredient freshness (recency of consumption)

### Key Business Logic
The app's core value proposition is **dietary variety tracking**:
- Tracks individual ingredient consumption over time
- Provides "freshness scores" for dishes based on how recently their ingredients were consumed
- Recommends dishes with ingredients that haven't been consumed recently
- Default avoidance period is 7 days for ingredient recommendations

## Mobile App Design

### Technology Stack (Planned)
- **Framework**: Flutter (Dart)
- **State Management**: Provider or Riverpod
- **HTTP Client**: Dio or http package
- **Local Storage**: SharedPreferences + Hive/SQLite
- **Navigation**: GoRouter
- **UI**: Material Design 3 with custom theming

### App Structure
5 main screens with bottom navigation:
1. **Home** - Dashboard and daily summary
2. **Ingredients** - Ingredient management and search
3. **Dishes** - Recipe collection and management
4. **Track** - Consumption logging interface
5. **Recommendations** - Smart dish suggestions

### Design System
- **Primary Colors**: Blue gradient (#3B82F6 to #1D4ED8)
- **Secondary**: Green accent (#10B981)
- **Typography**: Inter font family
- **Spacing**: 8px base unit system

## API Integration

### Authentication
- Currently no authentication implemented
- Ready for future JWT implementation

### Key API Patterns
- All datetime fields use ISO format (e.g., `2025-07-01T12:00:00Z`)
- Consumption can be logged for either individual ingredients or complete dishes
- Recommendation algorithm prioritizes dishes with ingredients not recently consumed
- Search functionality available for both ingredients and dishes

### API Response Structure
- Ingredients include: id, name, category, nutritionalInfo
- Dishes include: id, name, description, instructions, dishIngredients array
- Consumption logs include: id, consumedAt, quantity, unit, plus related ingredient/dish data
- Recommendations include: freshnessScore, recentIngredients count, reason explanations

## Development Workflow

### Testing Strategy
When implementing features, consider:
- **Unit Testing**: API service methods, business logic, data transformations
- **Widget Testing**: Screen components, form validation, navigation flows
- **Integration Testing**: API integration, local storage, end-to-end user flows

### Common Development Tasks
- Use the comprehensive API documentation for understanding endpoint specifications
- Reference the detailed UI design mockups for implementing mobile screens
- Follow the established data models and business logic patterns
- Implement offline-first approach with local caching and sync

## File Organization

- `API_DOCUMENTATION.md` - Complete REST API specification with all endpoints
- `ios-app-design.md` - Detailed mobile app design document with UI mockups and technical specifications

## Key Considerations

- **Offline Support**: Plan for caching frequently accessed data locally
- **Performance**: Implement lazy loading for large ingredient/dish lists
- **User Experience**: Focus on quick consumption logging and intuitive navigation
- **Dietary Variety**: The core feature is tracking ingredient consumption recency, not just calorie counting
- **Recommendations**: Algorithm should prioritize ingredient freshness (time since last consumption) over other factors