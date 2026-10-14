import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient({TokenStorage? storage, http.Client? httpClient})
      : _storage = storage ?? TokenStorage(),
        _http = httpClient ?? http.Client();

  final TokenStorage _storage;
  final http.Client _http;
  bool _refreshing = false;

  Future<dynamic> get(String path, {bool auth = false}) =>
      _send('GET', path, auth: auth);

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) =>
      _send('POST', path, body: body, auth: auth);

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) =>
      _send('PUT', path, body: body, auth: auth);

  Future<void> delete(String path, {Map<String, dynamic>? body, bool auth = true}) async {
    await _send('DELETE', path, body: body, auth: auth);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
    bool retrying = false,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final token = await _storage.accessToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    http.Response response;
    try {
      final encoded = body == null ? null : jsonEncode(body);
      switch (method) {
        case 'GET':
          response = await _http.get(uri, headers: headers).timeout(const Duration(seconds: 20));
          break;
        case 'POST':
          response = await _http.post(uri, headers: headers, body: encoded).timeout(const Duration(seconds: 20));
          break;
        case 'PUT':
          response = await _http.put(uri, headers: headers, body: encoded).timeout(const Duration(seconds: 20));
          break;
        case 'DELETE':
          response = await _http.delete(uri, headers: headers, body: encoded).timeout(const Duration(seconds: 20));
          break;
        default:
          throw ApiException('Méthode HTTP non supportée');
      }
    } on TimeoutException {
      throw const ApiException('Le serveur met trop de temps à répondre.');
    } on http.ClientException catch (e) {
      throw ApiException('Impossible de joindre le serveur (${e.message}).');
    } catch (e) {
      throw ApiException('Connexion au serveur impossible. Vérifiez que le backend tourne sur ${ApiConfig.baseUrl}.');
    }

    if (response.statusCode == 401 && auth && !retrying) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _send(method, path, body: body, auth: auth, retrying: true);
      }
    }

    return _decode(response);
  }

  Future<bool> _tryRefresh() async {
    if (_refreshing) return false;
    _refreshing = true;
    try {
      final refresh = await _storage.refreshToken;
      if (refresh == null || refresh.isEmpty) return false;
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh');
      final response = await _http
          .post(
            uri,
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode({'refreshToken': refresh}),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await _storage.save(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String? ?? refresh,
          username: data['username'] as String?,
        );
        return true;
      }
      await _storage.clear();
      return false;
    } catch (_) {
      return false;
    } finally {
      _refreshing = false;
    }
  }

  dynamic _decode(http.Response response) {
    final raw = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return raw;
    }
    String message = 'Erreur serveur (${response.statusCode})';
    if (raw is Map<String, dynamic>) {
      message = (raw['message'] as String?) ?? message;
      final fields = raw['fieldErrors'];
      if (fields is Map && fields.isNotEmpty) {
        message = fields.values.first.toString();
      }
    }
    throw ApiException(message, statusCode: response.statusCode);
  }
}
