/// App-wide constants and configuration.

/// Server URLs for different environments.
class ServerConfig {
  /// Local development server
  static const String localUrl = 'http://localhost:8080/';

  /// Production server (update when deployed)
  static const String productionUrl = 'https://api.gitradar.app/';

  /// Current server URL based on environment
  static String get currentUrl {
    // In debug mode, use local server
    // In release mode, use production
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction ? productionUrl : localUrl;
  }
}

/// Storage keys for SharedPreferences.
class StorageKeys {
  static const String sessionToken = 'session_token';
  static const String deviceId = 'device_id';
  static const String userId = 'user_id';
  static const String themeMode = 'theme_mode';
  static const String onboardingComplete = 'onboarding_complete';
}

/// App-wide limits and constraints.
class AppLimits {
  static const int maxRepositories = 10;
  static const int pageSize = 20;
}

/// Route paths for navigation.
class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String repositories = '/repositories';
  static const String addRepository = '/repositories/add';
  static const String activity = '/activity';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}
