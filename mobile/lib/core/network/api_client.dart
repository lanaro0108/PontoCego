import 'package:dio/dio.dart';

/// Candidate REST paths are documented in README. No remote implementation is
/// selected in demo mode and no authentication token or API call is fabricated.
class ApiClient {
  static const configuredUrl = String.fromEnvironment('API_BASE_URL');
  static Dio? create() {
    if (configuredUrl.isEmpty) return null;
    final uri = Uri.tryParse(configuredUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme)) {
      throw ArgumentError('API_BASE_URL deve ser uma URL HTTP(S) absoluta.');
    }
    return Dio(
      BaseOptions(
        baseUrl: configuredUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }
}
