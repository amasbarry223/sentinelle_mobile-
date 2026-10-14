import 'api_client.dart';
import 'token_storage.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String username;
  final String? userId;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    this.userId,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      username: json['username'] as String? ?? '',
      userId: json['userId']?.toString(),
    );
  }
}

class SentinelleApi {
  SentinelleApi({ApiClient? client, TokenStorage? storage})
      : _client = client ?? ApiClient(storage: storage ?? TokenStorage()),
        _storage = storage ?? TokenStorage();

  final ApiClient _client;
  final TokenStorage _storage;

  // Mobile client only. Web/admin endpoints are intentionally excluded here and
  // will be wired later to the admin dashboard when it is implemented.

  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final data = await _client.post(
      '/api/auth/register',
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    ) as Map<String, dynamic>;
    final session = AuthSession.fromJson(data);
    await _storage.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      username: session.username,
    );
    return session;
  }

  Future<AuthSession> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final data = await _client.post(
      '/api/auth/login',
      body: {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      },
    ) as Map<String, dynamic>;
    final session = AuthSession.fromJson(data);
    await _storage.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      username: session.username,
    );
    return session;
  }

  Future<Map<String, dynamic>?> currentUser() async {
    final token = await _storage.accessToken;
    if (token == null || token.isEmpty) return null;
    final data = await _client.get('/api/users/me', auth: true);
    return data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    final refresh = await _storage.refreshToken;
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await _client.post('/api/auth/logout', body: {'refreshToken': refresh});
      } catch (_) {}
    }
    await _storage.clear();
  }

  Future<Map<String, dynamic>> analyze({
    String? text,
    String? url,
    String? phone,
    String language = 'fr',
  }) async {
    final body = <String, dynamic>{'language': language};
    if (text != null && text.trim().isNotEmpty) body['text'] = text.trim();
    if (url != null && url.trim().isNotEmpty) body['url'] = url.trim();
    if (phone != null && phone.trim().isNotEmpty) body['phone'] = phone.trim();
    final data = await _client.post('/api/analyze', body: body);
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createReport({
    required String language,
    required String category,
    required String riskLevel,
    int? riskScore,
    String reportType = 'MESSAGE',
    String? targetValue,
    String? reasonCodes,
    bool anonymous = true,
  }) async {
    final token = await _storage.accessToken;
    final data = await _client.post(
      '/api/reports',
      auth: token != null && token.isNotEmpty,
      body: {
        'anonymous': anonymous || token == null,
        'language': language,
        'category': category,
        'riskLevel': riskLevel,
        if (riskScore != null) 'riskScore': riskScore,
        'reportType': reportType,
        if (targetValue != null && targetValue.isNotEmpty) 'targetValue': targetValue,
        if (reasonCodes != null) 'reasonCodes': reasonCodes,
      },
    );
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> latestModel() async {
    final data = await _client.get('/api/model/latest');
    return data as Map<String, dynamic>;
  }

  Future<List<dynamic>> syncPatterns({String? language}) async {
    final query = language == null ? '' : '?language=$language';
    final data = await _client.get('/api/patterns/sync$query');
    return data as List<dynamic>;
  }

  Future<List<dynamic>> publicContent({String language = 'fr'}) async {
    final data = await _client.get('/api/content/public?language=$language');
    return data as List<dynamic>;
  }

  Future<AuthSession> refreshSession() async {
    final refresh = await _storage.refreshToken;
    if (refresh == null || refresh.isEmpty) {
      throw StateError('Aucun refresh token disponible.');
    }

    final data = await _client.post(
      '/api/auth/refresh',
      body: {'refreshToken': refresh},
    ) as Map<String, dynamic>;

    final session = AuthSession.fromJson(data);
    await _storage.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      username: session.username,
    );
    return session;
  }
}
