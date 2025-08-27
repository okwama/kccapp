# Flutter App Dependencies Configuration

## Complete pubspec.yaml

```yaml
name: kcc_sales_force
description: KCC Sales Force Automation Mobile Application
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: ">=3.16.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # HTTP Client & API
  dio: ^5.4.0
  retrofit: ^4.0.3
  json_annotation: ^4.8.1

  # Local Storage & Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0

  # Navigation
  go_router: ^12.1.3

  # UI Components
  cupertino_icons: ^1.0.6
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  pull_to_refresh: ^2.0.0

  # Forms & Validation
  form_builder: ^9.1.1
  form_builder_validators: ^9.1.0
  image_picker: ^1.0.4
  file_picker: ^6.1.1

  # Location & Maps
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1

  # Charts & Analytics
  fl_chart: ^0.65.0
  syncfusion_flutter_charts: ^24.1.41

  # Date & Time
  intl: ^0.18.1
  table_calendar: ^3.0.9

  # Notifications
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  firebase_analytics: ^10.7.4

  # Biometric Authentication
  local_auth: ^2.1.7

  # Connectivity
  connectivity_plus: ^5.0.2

  # Permissions
  permission_handler: ^11.1.0

  # Utilities
  uuid: ^4.2.1
  url_launcher: ^6.2.2
  share_plus: ^7.2.1
  path_provider: ^2.1.1
  device_info_plus: ^9.1.1

  # PDF Generation
  pdf: ^3.10.7
  printing: ^5.11.1

  # Excel Export
  excel: ^2.1.0

  # QR Code
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1

  # Barcode
  mobile_scanner: ^3.5.6

  # Camera
  camera: ^0.10.5+5

  # Image Processing
  image: ^4.1.3

  # Localization
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  retrofit_generator: ^7.0.8
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1

  # Testing
  mockito: ^5.4.4
  mocktail: ^1.0.2
  integration_test:
    sdk: flutter

  # Linting & Formatting
  flutter_lints: ^3.0.1
  custom_lint: ^0.5.11
  riverpod_lint: ^2.3.9

  # Analysis
  dart_code_metrics: ^5.7.6

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/translations/

  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
        - asset: assets/fonts/Roboto-Light.ttf
          weight: 300

  # Platform-specific configurations
  android:
    package: com.kcc.salesforce
    minSdkVersion: 21
    targetSdkVersion: 34
    compileSdkVersion: 34

  ios:
    bundleIdentifier: com.kcc.salesforce
    minimumOsVersion: "12.0"
```

## Dependency Categories Explained

### 1. Core Flutter Dependencies
- **flutter**: Main Flutter SDK
- **cupertino_icons**: iOS-style icons

### 2. State Management
- **flutter_riverpod**: Modern state management solution
- **riverpod_annotation**: Code generation for Riverpod
- **riverpod_generator**: Generates provider code

### 3. HTTP & API Communication
- **dio**: HTTP client with interceptors
- **retrofit**: Type-safe HTTP client
- **json_annotation**: JSON serialization annotations
- **json_serializable**: JSON code generation

### 4. Local Storage
- **hive**: Fast local database
- **hive_flutter**: Flutter integration for Hive
- **flutter_secure_storage**: Secure storage for sensitive data
- **hive_generator**: Code generation for Hive

### 5. Navigation
- **go_router**: Declarative routing solution

### 6. UI Components
- **flutter_svg**: SVG image support
- **cached_network_image**: Network image caching
- **shimmer**: Loading placeholders
- **pull_to_refresh**: Pull-to-refresh functionality

### 7. Forms & Validation
- **form_builder**: Advanced form building
- **form_builder_validators**: Form validation
- **image_picker**: Image selection from gallery/camera
- **file_picker**: File selection

### 8. Location & Maps
- **google_maps_flutter**: Google Maps integration
- **geolocator**: Location services
- **geocoding**: Address geocoding

### 9. Charts & Analytics
- **fl_chart**: Flutter charts library
- **syncfusion_flutter_charts**: Advanced charting

### 10. Date & Time
- **intl**: Internationalization and formatting
- **table_calendar**: Calendar widget

### 11. Firebase Services
- **firebase_core**: Firebase initialization
- **firebase_messaging**: Push notifications
- **firebase_analytics**: User analytics

### 12. Security
- **local_auth**: Biometric authentication

### 13. Connectivity
- **connectivity_plus**: Network connectivity monitoring

### 14. Permissions
- **permission_handler**: Runtime permissions

### 15. Utilities
- **uuid**: Unique identifier generation
- **url_launcher**: URL opening
- **share_plus**: Content sharing
- **path_provider**: File system paths
- **device_info_plus**: Device information

### 16. Document Generation
- **pdf**: PDF creation
- **printing**: PDF printing
- **excel**: Excel file generation

### 17. Scanning
- **qr_flutter**: QR code generation
- **qr_code_scanner**: QR code scanning
- **mobile_scanner**: Barcode scanning
- **camera**: Camera access

### 18. Image Processing
- **image**: Image manipulation

### 19. Localization
- **flutter_localizations**: Flutter localization

## Development Dependencies

### Code Generation
- **build_runner**: Code generation runner
- **retrofit_generator**: Retrofit code generation

### Testing
- **mockito**: Mocking framework
- **mocktail**: Alternative mocking framework
- **integration_test**: Integration testing

### Code Quality
- **flutter_lints**: Flutter linting rules
- **custom_lint**: Custom linting rules
- **riverpod_lint**: Riverpod-specific linting
- **dart_code_metrics**: Code quality metrics

## Version Compatibility Matrix

| Flutter Version | Dart Version | Key Dependencies |
|----------------|--------------|------------------|
| 3.16.0+ | 3.2.0+ | flutter_riverpod: ^2.4.9 |
| 3.16.0+ | 3.2.0+ | go_router: ^12.1.3 |
| 3.16.0+ | 3.2.0+ | dio: ^5.4.0 |
| 3.16.0+ | 3.2.0+ | hive: ^2.2.3 |

## Platform Support

### Android
- **Minimum SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34

### iOS
- **Minimum Version**: 12.0
- **Target Version**: Latest

## Performance Considerations

### Image Optimization
```yaml
# Use cached_network_image for network images
cached_network_image: ^3.3.0

# Use flutter_svg for vector graphics
flutter_svg: ^2.0.9
```

### Memory Management
```yaml
# Use Hive for efficient local storage
hive: ^2.2.3
hive_flutter: ^1.1.0
```

### Network Optimization
```yaml
# Use Dio with interceptors for API calls
dio: ^5.4.0
retrofit: ^4.0.3
```

## Security Considerations

### Secure Storage
```yaml
# Use flutter_secure_storage for sensitive data
flutter_secure_storage: ^9.0.0
```

### Authentication
```yaml
# Use local_auth for biometric authentication
local_auth: ^2.1.7
```

## Testing Strategy

### Unit Testing
```yaml
# Use mockito for mocking
mockito: ^5.4.4
mocktail: ^1.0.2
```

### Integration Testing
```yaml
# Use integration_test for end-to-end testing
integration_test:
  sdk: flutter
```

## Code Quality

### Linting
```yaml
# Use flutter_lints for code quality
flutter_lints: ^3.0.1
custom_lint: ^0.5.11
riverpod_lint: ^2.3.9
```

### Metrics
```yaml
# Use dart_code_metrics for code analysis
dart_code_metrics: ^5.7.6
```

## Build Configuration

### Android
```yaml
android:
  package: com.kcc.salesforce
  minSdkVersion: 21
  targetSdkVersion: 34
  compileSdkVersion: 34
```

### iOS
```yaml
ios:
  bundleIdentifier: com.kcc.salesforce
  minimumOsVersion: "12.0"
```

## Asset Management

### Images
```yaml
assets:
  - assets/images/
  - assets/icons/
```

### Fonts
```yaml
fonts:
  - family: Roboto
    fonts:
      - asset: assets/fonts/Roboto-Regular.ttf
      - asset: assets/fonts/Roboto-Bold.ttf
        weight: 700
```

## Localization

### Translation Files
```yaml
assets:
  - assets/translations/
```

### Dependencies
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
```

This comprehensive `pubspec.yaml` configuration provides all the necessary dependencies for building a robust, scalable, and maintainable Flutter application that integrates seamlessly with your KCC API backend.
