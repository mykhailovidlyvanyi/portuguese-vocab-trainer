// lib/config/app_environment.dart

class AppEnvironment {
  static const String name = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'prod',
  );

  static const bool isDev = name == 'dev';

  static String screenTitle(String title) {
    return isDev ? '$title - dev' : title;
  }
}
