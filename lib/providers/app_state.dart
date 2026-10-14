import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../models/history_item.dart';
import '../models/report_item.dart';
import '../models/risk_level.dart';
import '../services/api_exception.dart';
import '../services/sentinelle_api.dart';
import '../services/token_storage.dart';

class AppState extends ChangeNotifier {
  AppState({SentinelleApi? api}) : _api = api ?? SentinelleApi();

  final SentinelleApi _api;
  final TokenStorage _tokens = TokenStorage();

  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  String userName = 'Citoyen';
  String userSubtitle = 'Mode visiteur';
  String? userEmail;
  bool isLoggedIn = false;
  bool backendReachable = false;
  String language = 'FR';
  bool audioVoiceOver = false;
  bool permissionSms = true;
  bool permissionOverlay = false;
  bool permissionNotifications = true;
  bool wifiOnlyRules = true;
  bool offlineMode = false;
  String rulesVersion = 'En attente de sync';
  String? lastApiError;

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }

  void setLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  void toggleAudioVoiceOver(bool value) {
    audioVoiceOver = value;
    notifyListeners();
  }

  void updatePermissions({bool? sms, bool? overlay, bool? notifs}) {
    if (sms != null) permissionSms = sms;
    if (overlay != null) permissionOverlay = overlay;
    if (notifs != null) permissionNotifications = notifs;
    notifyListeners();
  }

  void toggleWifiOnlyRules(bool val) {
    wifiOnlyRules = val;
    notifyListeners();
  }

  void toggleOfflineMode(bool val) {
    offlineMode = val;
    notifyListeners();
  }

  bool isAudioPlaying = false;
  String? currentlyPlayingText;

  void playBambaraAudio(String text, BuildContext context) {
    isAudioPlaying = true;
    currentlyPlayingText = text;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Écoute en bambara (Bamanankan) : $text',
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF166534),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Future.delayed(const Duration(seconds: 4), () {
      isAudioPlaying = false;
      currentlyPlayingText = null;
      notifyListeners();
    });
  }

  final List<HistoryItem> _history = [];
  List<HistoryItem> get history => _history;

  String historySearchQuery = '';
  String historyTypeFilter = 'Tous';
  String historyRiskFilter = 'Tous';

  void setHistorySearchQuery(String q) {
    historySearchQuery = q;
    notifyListeners();
  }

  void setHistoryTypeFilter(String type) {
    historyTypeFilter = type;
    notifyListeners();
  }

  void setHistoryRiskFilter(String risk) {
    historyRiskFilter = risk;
    notifyListeners();
  }

  List<HistoryItem> get filteredHistory {
    return _history.where((item) {
      if (historyTypeFilter != 'Tous') {
        if (historyTypeFilter == 'MM' && item.type != 'Mobile Money' && item.type != 'MM') {
          return false;
        } else if (historyTypeFilter != 'MM' && item.type != historyTypeFilter) {
          return false;
        }
      }
      if (historyRiskFilter != 'Tous') {
        if (item.riskLevel.label.split(' ').last != historyRiskFilter &&
            item.riskLevel.name != historyRiskFilter.toLowerCase()) {
          return false;
        }
      }
      if (historySearchQuery.trim().isNotEmpty) {
        final q = historySearchQuery.toLowerCase();
        final match = item.originalText.toLowerCase().contains(q) ||
            item.maskedText.toLowerCase().contains(q) ||
            item.type.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void deleteHistoryItem(String id) {
    _history.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearAllHistory() {
    _history.clear();
    notifyListeners();
  }

  final List<ReportItem> _reports = [];
  List<ReportItem> get reports => _reports;

  String victimSelectedSituation = "J'ai donné mon PIN / OTP";
  final Set<int> _completedVictimSteps = {};
  Set<int> get completedVictimSteps => _completedVictimSteps;

  void setVictimSituation(String sit) {
    victimSelectedSituation = sit;
    _completedVictimSteps.clear();
    notifyListeners();
  }

  void toggleVictimStep(int stepIndex) {
    if (_completedVictimSteps.contains(stepIndex)) {
      _completedVictimSteps.remove(stepIndex);
    } else {
      _completedVictimSteps.add(stepIndex);
    }
    notifyListeners();
  }

  Future<void> bootstrap() async {
    try {
      await syncDetectionRules();
    } catch (_) {}
    try {
      final me = await _api.currentUser();
      if (me != null) {
        isLoggedIn = true;
        userName = me['username'] as String? ?? userName;
        userEmail = me['email'] as String?;
        userSubtitle = 'Compte protégé';
        backendReachable = true;
      } else {
        final saved = await _tokens.username;
        if (saved != null && saved.isNotEmpty) {
          userName = saved;
        }
      }
    } catch (_) {
      isLoggedIn = false;
      userSubtitle = 'Mode visiteur';
    }
    notifyListeners();
  }

  Future<void> login(String usernameOrEmail, String password) async {
    final session = await _api.login(
      usernameOrEmail: usernameOrEmail.trim(),
      password: password,
    );
    isLoggedIn = true;
    backendReachable = true;
    userName = session.username.isNotEmpty ? session.username : usernameOrEmail;
    userSubtitle = 'Compte protégé';
    lastApiError = null;
    notifyListeners();
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final session = await _api.register(
      username: username.trim(),
      email: email.trim(),
      password: password,
    );
    isLoggedIn = true;
    backendReachable = true;
    userName = session.username.isNotEmpty ? session.username : username;
    userEmail = email.trim();
    userSubtitle = 'Profil sécurisé';
    lastApiError = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _api.logout();
    isLoggedIn = false;
    userName = 'Citoyen';
    userEmail = null;
    userSubtitle = 'Mode visiteur';
    notifyListeners();
  }

  Future<void> submitReport({
    required String title,
    required String details,
    String type = 'SMS',
    int? riskScore,
    String? riskLevel,
  }) async {
    final apiType = _reportTypeFor(type);
    final lang = language.toLowerCase() == 'bm' ? 'bm' : 'fr';
    final level = (riskLevel ?? 'MEDIUM').toUpperCase();
    final remote = await _api.createReport(
      language: lang,
      category: title,
      riskLevel: level,
      riskScore: riskScore,
      reportType: apiType,
      targetValue: details.length > 180 ? details.substring(0, 180) : details,
      reasonCodes: title,
      anonymous: !isLoggedIn,
    );

    final createdAt = remote['createdAt']?.toString();
    _reports.insert(
      0,
      ReportItem(
        id: remote['id']?.toString() ?? 'rep_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        dateText: _formatNow(createdAt),
        status: _statusLabel(remote['status']?.toString()),
        details: details,
      ),
    );
    notifyListeners();
  }

  Future<void> syncDetectionRules() async {
    final payload = await _api.latestModel();
    backendReachable = true;
    final version = payload['modelVersion'];
    if (version is Map<String, dynamic>) {
      final label = version['version'] as String? ?? 'sync';
      rulesVersion = 'v$label';
    } else {
      final patterns = await _api.syncPatterns(
        language: language.toLowerCase() == 'bm' ? 'bm' : 'fr',
      );
      rulesVersion = '${patterns.length} règles actives';
    }
    notifyListeners();
  }

  Future<AnalysisResult> analyzeInput({
    required String type,
    required String content,
    bool askPin = false,
    bool isUrgent = false,
    bool askPayment = false,
    String? situationTag,
  }) async {
    final enriched = _enrichContent(
      type: type,
      content: content,
      askPin: askPin,
      isUrgent: isUrgent,
      askPayment: askPayment,
      situationTag: situationTag,
    );

    AnalysisResult result;
    try {
      if (offlineMode) {
        result = _analyzeLocally(type: type, content: enriched, askPin: askPin, isUrgent: isUrgent, askPayment: askPayment);
      } else {
        result = await _analyzeRemote(type: type, content: enriched);
      }
    } on ApiException {
      result = _analyzeLocally(type: type, content: enriched, askPin: askPin, isUrgent: isUrgent, askPayment: askPayment);
      lastApiError = 'Analyse locale (serveur indisponible)';
    } catch (_) {
      result = _analyzeLocally(type: type, content: enriched, askPin: askPin, isUrgent: isUrgent, askPayment: askPayment);
    }

    _history.insert(
      0,
      HistoryItem(
        id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        maskedText: _mask(content),
        originalText: content,
        score: result.score,
        riskLevel: result.riskLevel,
        dateGroup: "Aujourd'hui",
        createdAt: DateTime.now(),
        result: result,
      ),
    );
    notifyListeners();
    return result;
  }

  String _enrichContent({
    required String type,
    required String content,
    required bool askPin,
    required bool isUrgent,
    required bool askPayment,
    String? situationTag,
  }) {
    if (type != 'Mobile Money') return content;
    final extras = <String>[
      if (situationTag != null) situationTag,
      if (askPin) 'demande PIN code secret OTP',
      if (isUrgent) 'urgent immédiat compte bloqué',
      if (askPayment) 'paiement transfert argent',
    ];
    return '$content ${extras.join(' ')}'.trim();
  }

  Future<AnalysisResult> _analyzeRemote({
    required String type,
    required String content,
  }) async {
    final lang = language.toLowerCase() == 'bm' ? 'bm' : 'fr';
    Map<String, dynamic> payload;
    switch (type) {
      case 'Lien':
        payload = await _api.analyze(url: content, language: lang);
        break;
      case 'Numéro':
        payload = await _api.analyze(phone: content, language: lang);
        break;
      default:
        payload = await _api.analyze(text: content, language: lang);
    }
    backendReachable = true;
    lastApiError = null;
    return _mapAnalyzeResponse(payload, type: type, content: content);
  }

  AnalysisResult _mapAnalyzeResponse(
    Map<String, dynamic> json, {
    required String type,
    required String content,
  }) {
    final score = (json['riskScore'] as num?)?.toInt() ?? 0;
    final band = json['riskBand'] as String?;
    final level = json['riskLevel'] as String?;
    final highRisk = json['highRiskAlert'] == true;
    final recommendation = json['recommendation'] as String? ??
        'Restez prudent face aux demandes inhabituelles.';
    final signals = json['signals'];
    final reasons = <String>[];
    if (signals is List) {
      for (final item in signals) {
        if (item is Map<String, dynamic>) {
          final label = item['label'] as String? ?? item['code'] as String? ?? '';
          final explanation = item['explanation'] as String? ?? '';
          if (label.isNotEmpty) {
            reasons.add(explanation.isNotEmpty ? '$label : $explanation' : label);
          }
        }
      }
    }
    if (reasons.isEmpty) {
      reasons.add('Analyse serveur Sentinelle Mali');
    }

    final risk = _riskFromApi(band, level, score);
    return AnalysisResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      query: content,
      score: score,
      riskLevel: risk,
      verdictFr: recommendation,
      verdictBm: language == 'BM'
          ? recommendation
          : "I janto i yɛrɛ la. Kana i ka kɔdi di mɔgɔ si ma.",
      adviceHeadline: highRisk
          ? 'Ne donnez pas votre PIN ni votre OTP'
          : recommendation,
      adviceBody: recommendation,
      reasons: reasons,
      highlightedText: content,
      timestamp: DateTime.now(),
      isStopAlert: highRisk || risk == RiskLevel.critique,
      sender: type == 'Numéro' ? content : null,
    );
  }

  RiskLevel _riskFromApi(String? band, String? level, int score) {
    final merged = '${band ?? ''} ${level ?? ''}'.toUpperCase();
    if (merged.contains('CRIT') || score > 80) return RiskLevel.critique;
    if (merged.contains('ELEVE') || merged.contains('HIGH') || score > 60) {
      return RiskLevel.eleve;
    }
    if (merged.contains('MODER') || merged.contains('MEDIUM') || score > 30) {
      return RiskLevel.modere;
    }
    return RiskLevel.faible;
  }

  AnalysisResult _analyzeLocally({
    required String type,
    required String content,
    bool askPin = false,
    bool isUrgent = false,
    bool askPayment = false,
  }) {
    final lower = content.toLowerCase();
    int calculatedScore = 15;
    RiskLevel calculatedLevel = RiskLevel.faible;
    List<String> reasons = [];
    String verdictFr = 'Aucun signe de fraude détecté. Restez prudent.';
    String verdictBm = "Kojugu si t'a kɔnɔ. I janto i yɛrɛ la.";
    String headline = 'Vous pouvez continuer, restez prudent';
    String? body = 'Le message semble régulier mais gardez vos réflexes de sécurité.';
    bool isStop = false;

    final hasPinOtp = lower.contains('pin') ||
        lower.contains('otp') ||
        lower.contains('code secret') ||
        lower.contains('mot de passe') ||
        askPin;
    final hasGain = lower.contains('gagné') ||
        lower.contains('gain') ||
        lower.contains('félicitation') ||
        lower.contains('tirage') ||
        lower.contains('500 000') ||
        lower.contains('lottery');
    final hasUrgent = lower.contains('urgent') ||
        lower.contains('bloqué') ||
        lower.contains('immédiat') ||
        lower.contains('avant ce soir') ||
        isUrgent;
    final hasSuspiciousLink = lower.contains('.xyz') ||
        lower.contains('bit.ly') ||
        lower.contains('tinyurl') ||
        lower.contains('http://') ||
        lower.contains('wa.me');
    final hasOperatorSpoof = lower.contains('orange') ||
        lower.contains('moov') ||
        lower.contains('wave') ||
        lower.contains('sama money');

    if (hasPinOtp || (hasOperatorSpoof && (hasGain || hasUrgent))) {
      calculatedScore = 92;
      calculatedLevel = RiskLevel.critique;
      isStop = true;
      verdictFr = "Tentative d'arnaque presque certaine. Ne répondez pas.";
      verdictBm = "Ngalon don ! I kani i ka kɔdi di mɔgɔ si ma.";
      headline = 'Ne donnez pas votre PIN ni votre OTP';
      body = "Aucun opérateur ne vous demandera votre code. Raccrochez maintenant.";
      reasons = [
        'Analyse locale (hors-ligne)',
        'Type : Faux agent Mobile Money',
        if (hasPinOtp) 'Demande de mot de passe ou code confidentiel',
        if (hasOperatorSpoof) "Usurpation de l'identité d'un opérateur téléphonique",
      ];
    } else if (hasSuspiciousLink || (hasUrgent && askPayment)) {
      calculatedScore = 48;
      calculatedLevel = RiskLevel.modere;
      verdictFr = "Plusieurs signes suspects. Vérifiez avant d'agir.";
      verdictBm = "Hakilitigiya kɛ ! Kana digi liyɛn nin kan.";
      headline = 'Vérifiez auprès de votre opérateur';
      body = 'Ce message incite à une action rapide via un canal non certifié.';
      reasons = [
        'Analyse locale (hors-ligne)',
        'Faux blocage / mise à jour de compte',
        if (hasSuspiciousLink) 'Lien raccourci ou suspect',
      ];
    } else {
      reasons = [
        'Analyse locale (hors-ligne)',
        'Aucun signal suspect identifié',
      ];
    }

    return AnalysisResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      query: content,
      score: calculatedScore,
      riskLevel: calculatedLevel,
      verdictFr: verdictFr,
      verdictBm: verdictBm,
      adviceHeadline: headline,
      adviceBody: body,
      reasons: reasons,
      highlightedText: content,
      timestamp: DateTime.now(),
      isStopAlert: isStop,
      sender: type == 'Numéro' ? content : null,
    );
  }

  String _mask(String content) {
    if (content.length > 25) {
      return '${content.substring(0, 5)}███ ${content.substring(8, content.length.clamp(12, 12))}███...';
    }
    return content;
  }

  String _reportTypeFor(String type) {
    switch (type) {
      case 'Lien':
        return 'LINK';
      case 'Numéro':
        return 'PHONE';
      default:
        return 'MESSAGE';
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'VALIDATED':
        return 'Validé';
      case 'REJECTED':
        return 'Rejeté';
      case 'PENDING':
      default:
        return 'Envoyé';
    }
  }

  String _formatNow(String? iso) {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} · ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
