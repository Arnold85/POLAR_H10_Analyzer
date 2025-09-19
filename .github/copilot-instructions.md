# Polar H10 Analyzer Flutter App - Development Instructions

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Project Overview

Polar H10 Analyzer is a Flutter application for capturing, storing, and analyzing ECG, heart rate, and RR interval data from Polar H10 sensors. The app uses Android as the primary platform with iOS portability planned. It features local data storage, CSV/EDF/PDF export capabilities, and AI-powered analysis using local models and optional cloud LLM integration.

## Working Effectively

### Environment Setup
- Install Flutter SDK: `snap install flutter --classic` or download from https://flutter.dev/docs/get-started/install/linux
- Alternative if snap fails: `cd /tmp && git clone -b stable --depth 1 https://github.com/flutter/flutter.git && export PATH="/tmp/flutter/bin:$PATH"`
- Verify installation: `flutter doctor` -- may download additional components, takes 60-120 seconds. NEVER CANCEL. Set timeout to 180+ seconds.
- Accept Android licenses: `flutter doctor --android-licenses` (optional, only needed for Android builds)

### Bootstrap and Build Process
- Navigate to project root: `cd /path/to/POLAR_H10_Analyzer`
- Install dependencies: `flutter pub get` -- takes 30-60 seconds. NEVER CANCEL.
- Generate code (if needed): `flutter packages pub run build_runner build` -- takes 60-120 seconds. NEVER CANCEL. Set timeout to 180+ seconds.
- Clean build (if issues): `flutter clean && flutter pub get`

### Build Commands
- Debug build (Android): `flutter build apk --debug` -- takes 120-180 seconds. NEVER CANCEL. Set timeout to 300+ seconds.
- Release build (Android): `flutter build apk --release` -- takes 180-300 seconds. NEVER CANCEL. Set timeout to 420+ seconds.
- Debug build (Linux): `flutter build linux --debug` -- takes 90-150 seconds. NEVER CANCEL. Set timeout to 240+ seconds.
- Build for other platforms:
  - iOS: `flutter build ios` (requires macOS and Xcode)
  - Windows: `flutter build windows` (requires Windows)
  - Web: `flutter build web` -- takes 60-120 seconds. NEVER CANCEL. Set timeout to 180+ seconds.

### Testing
- Run all tests: `flutter test` -- takes 15-30 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
- Run specific test: `flutter test test/domain/models/hrv_metrics_test.dart`
- Run widget tests: `flutter test test/widget_test.dart`
- Test coverage: `flutter test --coverage`
- **IMPORTANT**: In restricted environments where Flutter SDK downloads fail, tests may not run. Document this limitation and focus on code analysis instead.

### Development Server
- Start development server: `flutter run` -- takes 60-90 seconds for initial build. NEVER CANCEL. Set timeout to 180+ seconds.
- Hot reload: Press `r` in terminal after changes
- Hot restart: Press `R` in terminal
- Quit: Press `q` in terminal

### Code Quality
- Format code: `dart format .` -- takes 5-10 seconds
- Analyze code: `flutter analyze` -- takes 15-30 seconds
- ALWAYS run `dart format .` and `flutter analyze` before committing
- Ensure analysis shows no errors or the CI will fail

## Validation

### Manual Testing Scenarios
After making changes, ALWAYS test these user scenarios:
- **Navigation Flow**: Start app, navigate between all 4 tabs (Dashboard, Sessions, Analysis, Settings), verify content displays correctly
- **Theme Testing**: Toggle between light and dark mode in system settings, verify app adapts properly
- **Widget Tests**: Run `flutter test test/widget_test.dart` to verify tab navigation and content display
- **Model Tests**: Run domain model tests to ensure data integrity: `flutter test test/domain/models/`

### Functional Validation
- Verify app starts without crashes: `flutter run` and observe startup
- Check Material 3 theming is properly applied
- Ensure all navigation routes work correctly
- Validate placeholder content displays on all pages
- Test Riverpod state management integration

## Project Structure

### Key Directories
```
lib/
├── main.dart                    # App entry point
├── src/
    ├── app.dart                 # Main app widget with routing and theming
    ├── constants/               # App strings and constants
    │   └── app_strings.dart     # Localized text constants
    ├── domain/                  # Business logic and models
    │   ├── models/              # Domain models (HRV, heart rate, stress)
    │   └── interfaces/          # Abstract interfaces for services
    ├── features/                # Feature-based organization
    │   ├── dashboard/           # Live monitoring page
    │   ├── sessions/            # Session history and management
    │   ├── analytics/           # Analysis and insights
    │   └── settings/            # App configuration
    ├── routing/                 # GoRouter configuration
    │   └── app_router.dart      # Navigation setup with shell routing
    ├── theme/                   # Material 3 theming
    │   └── app_theme.dart       # Light/dark theme configuration
    └── widgets/                 # Shared UI components
        ├── app_navigation_shell.dart  # Bottom navigation shell
        ├── page_header.dart     # Consistent page headers
        └── placeholder_card.dart # Development placeholder cards

test/
├── domain/models/              # Unit tests for domain models
└── widget_test.dart            # Integration tests for UI navigation

docs/
├── polar_h10_app_plan.md       # Complete development roadmap
└── analysis_architecture.md   # AI/analysis component architecture
```

### Important Files to Know
- `pubspec.yaml`: Dependencies and project configuration
- `analysis_options.yaml`: Dart analyzer and linting rules
- `lib/src/domain/domain.dart`: Exported domain layer interface
- `lib/src/routing/app_router.dart`: Navigation configuration
- `android/app/build.gradle.kts`: Android build configuration
- `docs/polar_h10_app_plan.md`: 12-section development plan with architecture details

## Architecture Patterns

### State Management
- **Riverpod**: Used for dependency injection and state management
- **Pattern**: Consumer widgets and providers throughout the app
- **Key Provider**: `appRouterProvider` in `app_router.dart`

### Navigation
- **GoRouter**: Declarative routing with shell navigation
- **Pattern**: StatefulShellRoute with 4 main branches (Dashboard, Sessions, Analysis, Settings)
- **Navigation Keys**: Separate navigator keys for each tab to maintain state

### Domain Layer
- **Models**: Immutable domain models using Dart classes with const constructors
- **Key Models**: `HrvMetrics`, `HeartRateAnalysis`, `StressIndicator`, `AnalysisResult`
- **Testing**: Comprehensive unit tests for all domain models

### UI Architecture
- **Material 3**: Modern theming with light/dark mode support
- **Feature Structure**: Each feature has its own presentation layer
- **Shared Widgets**: Reusable components in `widgets/` directory

## Common Tasks

### Adding New Features
1. Create feature directory under `lib/src/features/`
2. Add presentation layer with page widgets
3. Update routing in `app_router.dart` if needed
4. Add navigation to `app_navigation_shell.dart` if it's a main tab
5. Update `app_strings.dart` for any new text
6. Write tests in corresponding `test/` directory

### Modifying Domain Models
1. Update model in `lib/src/domain/models/`
2. Run `flutter packages pub run build_runner build` if using code generation
3. Update corresponding tests in `test/domain/models/`
4. Ensure `flutter test` passes
5. Update any dependent UI code

### Platform-Specific Code
- **Android**: Modify `android/app/build.gradle.kts` for build configuration
- **iOS**: Use Xcode to modify iOS-specific settings (requires macOS)
- **Linux**: CMake files in `linux/` directory handle native compilation
- **Windows**: CMake files in `windows/` directory handle native compilation

### Dependencies
Key dependencies include:
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `syncfusion_flutter_charts`: Data visualization  
- `tflite_flutter`: Local AI models
- `ml_linalg`: Signal processing
- `build_runner`, `freezed`, `json_serializable`: Code generation

## Development Tips

### Performance
- Hot reload is available during development - use `r` in terminal
- Hot restart with `R` if state becomes inconsistent
- Use `flutter run --release` for performance testing

### Debugging
- Use `flutter logs` to see detailed logging
- Debug in IDE with breakpoints in Dart code
- Use `flutter inspector` for widget tree debugging

### Code Style
- Follow the existing patterns in the codebase
- Use `dart format .` to maintain consistent formatting
- Prefer const constructors where possible
- Use descriptive variable and method names

### Testing Strategy
- Write unit tests for all domain models
- Add widget tests for new UI components
- Test navigation flows end-to-end
- Mock external dependencies in tests

## CI/CD Considerations

### Pre-commit Checks
Always run before committing:
1. `dart format .`
2. `flutter analyze` 
3. `flutter test`

### Build Validation
The following commands should complete successfully:
- `flutter pub get`
- `flutter analyze` (no errors)
- `flutter test` (all tests pass)
- `flutter build apk --debug` (Android debug build)

## Troubleshooting

### Common Issues
- **Build failures**: Run `flutter clean && flutter pub get`
- **Code generation issues**: Run `flutter packages pub run build_runner clean` then `flutter packages pub run build_runner build`
- **Analysis errors**: Check `analysis_options.yaml` for configuration
- **Test failures**: Ensure models are properly imported and test data is valid

### Platform Issues
- **Android**: Verify Android SDK and licenses with `flutter doctor`
- **Linux**: Ensure CMake and build tools are installed
- **Network issues**: Some Flutter downloads may be restricted in certain environments. If Flutter SDK download fails, the project structure and code can still be analyzed and modified.
- **Flutter unavailable**: If Flutter commands fail due to SDK issues, you can still analyze Dart files, modify code structure, and validate syntax manually.

Remember: This is a prototype/development project focusing on Android with future iOS portability. The BLE integration with Polar H10 sensors is planned but not yet implemented. The current codebase provides the architectural foundation for the full application.

## Common Command Outputs

The following are outputs from frequently run commands. Reference them instead of viewing, searching, or running bash commands to save time when possible.

### Repository Structure
```
ls -la [repo-root]
.github/                        # GitHub configuration and workflows  
.git/                          # Git repository data
README.md                      # Basic project description
pubspec.yaml                   # Flutter dependencies and configuration
pubspec.lock                   # Locked dependency versions
analysis_options.yaml          # Dart analyzer and linting configuration
lib/                          # Main source code
test/                         # Test files
docs/                         # Project documentation
android/                      # Android platform code
ios/                          # iOS platform code
linux/                        # Linux platform code  
windows/                      # Windows platform code
macos/                        # macOS platform code
web/                          # Web platform code
```

### Key Library Files
```
find lib/ -name "*.dart"
lib/main.dart
lib/src/app.dart
lib/src/constants/app_strings.dart
lib/src/domain/models/analysis_result.dart
lib/src/domain/models/heart_rate_analysis.dart
lib/src/domain/models/hrv_metrics.dart
lib/src/domain/models/stress_indicator.dart
lib/src/routing/app_router.dart
lib/src/theme/app_theme.dart
lib/src/features/dashboard/presentation/dashboard_page.dart
lib/src/features/sessions/presentation/sessions_page.dart
lib/src/features/analytics/presentation/analytics_page.dart
lib/src/features/settings/presentation/settings_page.dart
```

### Test Files
```
find test/ -name "*.dart"
test/widget_test.dart
test/domain/models/hrv_metrics_test.dart
test/domain/models/heart_rate_analysis_test.dart  
test/domain/models/stress_indicator_test.dart
```