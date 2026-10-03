import 'analysis_result.dart';
import 'risk_level.dart';

class HistoryItem {
  final String id;
  final String type; // 'SMS', 'Lien', 'Numéro', 'MM'
  final String maskedText;
  final String originalText;
  final int score;
  final RiskLevel riskLevel;
  final String dateGroup; // "Aujourd'hui", "Hier", "01/10/2026"
  final DateTime createdAt;
  final AnalysisResult result;

  HistoryItem({
    required this.id,
    required this.type,
    required this.maskedText,
    required this.originalText,
    required this.score,
    required this.riskLevel,
    required this.dateGroup,
    required this.createdAt,
    required this.result,
  });
}
