import 'package:flutter/foundation.dart';

/// URL du backend Spring Boot (Sentinelle-Mali, port 8081).
///
/// Surcharge : `flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8081`
/// (nécessaire sur un téléphone physique, à la place de localhost).
class ApiConfig {
  static const String _fromEnv = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_fromEnv.isNotEmpty) {
      return _fromEnv.endsWith('/') ? _fromEnv.substring(0, _fromEnv.length - 1) : _fromEnv;
    }
    if (kIsWeb) {
      return 'http://localhost:8081';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8081';
    }
    return 'http://localhost:8081';
  }
}
