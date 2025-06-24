# SiMenang KRPG Mobile App

A Flutter mobile application for Petrokimia Gresik Swimming Club that helps manage training activities, competitions, and athlete management.

## Overview

SiMenang KRPG Mobile App is designed to complement the existing web application, providing mobile access to club members, coaches, and administrators. The app follows a reusable component-based architecture that mirrors the web application's UI patterns while optimizing for mobile use.

## Features

- **User Authentication**: Secure login for athletes, coaches, and leaders
- **Training Management**: View, join, and manage training sessions
- **Competition Management**: Register, track, and manage competitions
- **Athlete Management**: Track progress, attendance, and performance
- **Dashboard**: Personalized dashboard based on user role

## Component System

The app is built on a comprehensive component system that ensures consistency and reusability across the application. The main components include:

### Card Components
- `KRPGCard`: Base card component with variants for dashboard, statistics, lists, training, and competitions

### Button Components
- `KRPGButton`: Flexible button component with variants for primary, secondary, success, and danger actions

### Badge Components
- `KRPGBadge`: Status indicator component with variants for success, warning, danger, info, and neutral states

### Training Components
- `TrainingCard`: Specialized card for displaying training information

### Competition Components
- `CompetitionCard`: Specialized card for displaying competition information

## Architecture

The app follows the Model-View-Controller (MVC) pattern:

- **Models**: Data structures representing core entities like User, Training, and Competition
- **Views**: UI components and screens
- **Controllers**: Business logic and state management

## Role-Based Navigation

The app provides different navigation experiences based on user roles:

- **Leader**: Full access to all features and administrative functions
- **Coach**: Access to training management, athlete progress, and competitions
- **Athlete**: Access to personal training schedule, competition registration, and performance tracking

## Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/simenang_krpg.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Component Showcase

The app includes a component showcase screen that demonstrates all the available components. To access it:

1. Run the app
2. The showcase screen is set as the initial route for demonstration purposes

## Documentation

For detailed documentation on the component system, refer to:

- [Component Documentation](lib/docs/component_documentation.md)

## Backend Integration

The app is designed to integrate with the existing Laravel backend API. The API base URL can be configured in `lib/config/app_config.dart`.

## Contributors

- [Your Name](https://github.com/your-username)

## License

This project is proprietary and owned by Petrokimia Gresik Swimming Club.
