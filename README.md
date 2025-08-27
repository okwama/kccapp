# KCC Sales Force

A Flutter application for sales force automation built with Clean Architecture.

## Features

- Authentication & Authorization
- Client Management
- Product Catalog
- Order Management
- Sales Reports
- User Profile Management

## Architecture

This project follows Clean Architecture principles with the following layers:

- **Presentation Layer**: UI components, pages, and state management
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and models

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: Hive
- **UI Components**: Material 3

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── constants/       # App constants
│   ├── errors/          # Error handling
│   ├── network/         # Network configuration
│   ├── storage/         # Local storage
│   ├── theme/           # App theme
│   └── navigation/      # Navigation setup
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── dashboard/      # Dashboard
│   ├── clients/        # Client management
│   ├── products/       # Product catalog
│   ├── orders/         # Order management
│   ├── reports/        # Sales reports
│   └── profile/        # User profile
└── main.dart           # App entry point
```
