import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../models/history_item.dart';
import '../models/report_item.dart';
import '../models/risk_level.dart';

class AppState extends ChangeNotifier {
  // Navigation
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // User Profile & Settings
  String userName = "Aïcha";
  String userSubtitle = "Compte protégé";
  String language = "FR"; // "FR" or "BM"
  bool audioVoiceOver = false;
  bool permissionSms = true;
  bool permissionOverlay = false;
  bool permissionNotifications = true;
  bool wifiOnlyRules = true;
  bool offlineMode = false;
  String rulesVersion = "v2.4.1 · 02/10/2026";

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

  // Audio Playback Simulation for Bambara
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

  // History Data
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

  // Scam Reports List
  final List<ReportItem> _reports = [
    ReportItem(
      id: 'rep_1',
      title: 'Faux gain',
      dateText: '03/10/2026 · 08:29',
      status: 'Envoyé',
      details: 'SMS reçu annonçant 500 000 FCFA avec demande de code PIN.',
    ),
    ReportItem(
      id: 'rep_2',
      title: 'Faux agent MM',
      dateText: '03/10/2026 · 11:29',
      status: 'Envoyé',
      details: 'Appel téléphonique se présentant comme agent Orange Money réclamant le code secret.',
    ),
  ];
  List<ReportItem> get reports => _reports;

  void addReport(String title, String details) {
    _reports.insert(
      0,
      ReportItem(
        id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        dateText: '03/10/2026 · 14:15',
        status: 'Envoyé',
        details: details,
      ),
    );
    notifyListeners();
  }

  // Victim Guide Emergency Checkpoints
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

  AppState() {
    _initDefaultHistory();
  }

  void _initDefaultHistory() {
    final sample1Result = AnalysisResult(
      id: 'res_1',
      type: 'SMS',
      query: 'Orange Money : Vous avez gagné 500 000 FCFA ! Envoyez votre code PIN au 7X XX XX...',
      score: 100,
      riskLevel: RiskLevel.critique,
      verdictFr: "Tentative d'arnaque certaine. Ne répondez jamais.",
      verdictBm: "Ngalon don ! I kani i ka kɔdi di mɔgɔ si ma.",
      adviceHeadline: "Ne donnez pas votre PIN ni votre OTP",
      adviceBody: "Aucun opérateur ne vous demandera votre code. Raccrochez maintenant.",
      reasons: [
        "312 signalements de la communauté",
        "Type : Faux agent Mobile Money",
        "Demande explicite de code confidentiel",
      ],
      highlightedText: "Orange Money : Vous avez gagné 500 000 FCFA ! Envoyez votre code PIN",
      sender: "+223 76 12 34 56",
      timestamp: DateTime.now(),
      isStopAlert: true,
    );

    final sample2Result = AnalysisResult(
      id: 'res_2',
      type: 'SMS',
      query: "Bonjour, c'est Fatoumata. Le marché c'est demain à 9h, n'oublie pas le tissu.",
      score: 8,
      riskLevel: RiskLevel.faible,
      verdictFr: "Aucun signe de fraude détecté. Restez prudent.",
      verdictBm: "Kojugu si t'a kɔnɔ. I janto i yɛrɛ la.",
      adviceHeadline: "Vous pouvez continuer, restez prudent",
      adviceBody: "Le contenu correspond à un échange personnel sans sollicitation financière.",
      reasons: [
        "Aucun signal suspect",
        "Aucun lien externe ni demande d'argent",
      ],
      highlightedText: "Bonjour, c'est Fatoumata. Le marché c'est demain à 9h, n'oublie pas le tissu.",
      sender: "+223 70 44 22 11",
      timestamp: DateTime.now(),
    );

    final sample3Result = AnalysisResult(
      id: 'res_3',
      type: 'SMS',
      query: "Votre compte Moov sera mis à jour. Cliquez ici : bit.ly/moov-mali avant ce soir.",
      score: 48,
      riskLevel: RiskLevel.modere,
      verdictFr: "Plusieurs signes suspects. Vérifiez avant d'agir.",
      verdictBm: "Hakilitigiya kɛ ! Kana digi liyɛn nin kan.",
      adviceHeadline: "Vérifiez auprès de votre opérateur",
      adviceBody: "Les opérateurs officiels n'utilisent jamais de réducteurs de liens (bit.ly).",
      reasons: [
        "Faux blocage / mise à jour de compte",
        "Marque d'opérateur citée par un inconnu",
        "Lien raccourci suspect",
      ],
      highlightedText: "Votre compte Moov sera mis à jour. Cliquez ici : bit.ly/moov-mali avant ce soir.",
      sender: "+223 99 88 77 66",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    );

    final sample4Result = AnalysisResult(
      id: 'res_4',
      type: 'Lien',
      query: "orange-money-mali.xyz/remboursement-urgent",
      score: 82,
      riskLevel: RiskLevel.critique,
      verdictFr: "Site frauduleux usurpant Orange Money.",
      verdictBm: "Siteweb juguman don, i kana i ka kunnafoniw bila yen.",
      adviceHeadline: "Ne cliquez pas sur ce lien",
      adviceBody: "Le nom de domaine .xyz est fréquemment utilisé par les escrocs.",
      reasons: [
        "187 signalements de la communauté",
        "Extension de domaine .xyz suspecte",
        "Usurpation d'identité de marque bancaire",
      ],
      highlightedText: "orange-money-mali.xyz/remboursement-urgent",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isStopAlert: true,
    );

    _history.addAll([
      HistoryItem(
        id: 'hist_1',
        type: 'SMS',
        maskedText: 'Or███ Mo███ : Vo███ av███ ga...',
        originalText: 'Orange Money : Vous avez gagné 500 000 FCFA !',
        score: 100,
        riskLevel: RiskLevel.critique,
        dateGroup: "Aujourd'hui",
        createdAt: DateTime.now(),
        result: sample1Result,
      ),
      HistoryItem(
        id: 'hist_2',
        type: 'SMS',
        maskedText: "Bo███, c'es Fa███. L...",
        originalText: "Bonjour, c'est Fatoumata. Le marché c'est demain...",
        score: 8,
        riskLevel: RiskLevel.faible,
        dateGroup: "Aujourd'hui",
        createdAt: DateTime.now(),
        result: sample2Result,
      ),
      HistoryItem(
        id: 'hist_3',
        type: 'SMS',
        maskedText: 'Vo███ co███ Mo███ se███ mi███...',
        originalText: 'Votre compte Moov sera mis à jour. Cliquez...',
        score: 48,
        riskLevel: RiskLevel.modere,
        dateGroup: "Hier",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        result: sample3Result,
      ),
      HistoryItem(
        id: 'hist_4',
        type: 'Lien',
        maskedText: 'or███-mo███-ma███.xy█/re███...',
        originalText: 'orange-money-mali.xyz/remboursement',
        score: 82,
        riskLevel: RiskLevel.critique,
        dateGroup: "Hier",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        result: sample4Result,
      ),
    ]);
  }

  AnalysisResult analyzeInput({
    required String type,
    required String content,
    bool askPin = false,
    bool isUrgent = false,
    bool askPayment = false,
    String? situationTag,
  }) {
    final lower = content.toLowerCase();
    int calculatedScore = 15;
    RiskLevel calculatedLevel = RiskLevel.faible;
    List<String> reasons = [];
    String verdictFr = "Aucun signe de fraude détecté. Restez prudent.";
    String verdictBm = "Kojugu si t'a kɔnɔ. I janto i yɛrɛ la.";
    String headline = "Vous pouvez continuer, restez prudent";
    String? body = "Le message semble régulier mais gardez vos réflexes de sécurité.";
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
      headline = "Ne donnez pas votre PIN ni votre OTP";
      body = "Aucun opérateur ne vous demandera votre code. Raccrochez maintenant.";
      reasons = [
        "312 signalements de la communauté",
        "Type : Faux agent Mobile Money",
        if (hasPinOtp) "Demande de mot de passe ou code confidentiel",
        if (hasOperatorSpoof) "Usurpation de l'identité d'un opérateur téléphonique",
      ];
    } else if (hasSuspiciousLink || (hasUrgent && askPayment)) {
      calculatedScore = 48;
      calculatedLevel = RiskLevel.modere;
      verdictFr = "Plusieurs signes suspects. Vérifiez avant d'agir.";
      verdictBm = "Hakilitigiya kɛ ! Kana digi liyɛn nin kan.";
      headline = "Vérifiez auprès de votre opérateur";
      body = "Ce message incite à une action rapide via un canal non certifié.";
      reasons = [
        "Faux blocage / mise à jour de compte",
        "Marque d'opérateur citée par un inconnu",
        if (hasSuspiciousLink) "Lien raccourci ou suspect",
      ];
    } else if (content.contains('76 12 34 56') || lower.contains('76123456')) {
      calculatedScore = 92;
      calculatedLevel = RiskLevel.critique;
      isStop = true;
      verdictFr = "Numéro fortement signalé par les utilisateurs.";
      verdictBm = "Nin nimɔrɔ man ɲi ! Mɔgɔ caman y'ajira ko ngalonkɛla don.";
      headline = "Bloquez ce numéro immédiatement";
      body = "Plusieurs signalements confirment des appels de faux agents Mobile Money.";
      reasons = [
        "312 signalements de la communauté",
        "Type : Faux agent Mobile Money",
        "+223 76 12 34 56",
      ];
    } else {
      reasons = [
        "Aucun signal suspect identifié",
        "Pas de lien ou de demande financière",
      ];
    }

    final newResult = AnalysisResult(
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
      sender: type == 'Numéro' ? content : '+223 76 12 34 56',
    );

    String masked = content;
    if (content.length > 25) {
      masked = "${content.substring(0, 5)}███ ${content.substring(8, 12)}███...";
    }

    _history.insert(
      0,
      HistoryItem(
        id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        maskedText: masked,
        originalText: content,
        score: calculatedScore,
        riskLevel: calculatedLevel,
        dateGroup: "Aujourd'hui",
        createdAt: DateTime.now(),
        result: newResult,
      ),
    );

    notifyListeners();
    return newResult;
  }
}
