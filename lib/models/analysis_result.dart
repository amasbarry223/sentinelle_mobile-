import 'risk_level.dart';

class AnalysisResult {
  final String id;
  final String type; // 'SMS', 'Lien', 'Numéro', 'Mobile Money'
  final String query;
  final int score;
  final RiskLevel riskLevel;
  final String verdictFr;
  final String verdictBm;
  final String adviceHeadline;
  final String? adviceBody;
  final List<String> reasons;
  final String highlightedText;
  final String? sender;
  final DateTime timestamp;
  final bool isStopAlert;

  AnalysisResult({
    required this.id,
    required this.type,
    required this.query,
    required this.score,
    required this.riskLevel,
    required this.verdictFr,
    required this.verdictBm,
    required this.adviceHeadline,
    this.adviceBody,
    required this.reasons,
    required this.highlightedText,
    this.sender,
    required this.timestamp,
    this.isStopAlert = false,
  });
}
