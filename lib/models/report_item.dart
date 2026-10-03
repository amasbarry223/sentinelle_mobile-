class ReportItem {
  final String id;
  final String title;
  final String dateText;
  final String status; // 'Envoyé', 'En vérification'
  final String details;

  ReportItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.status = 'Envoyé',
    required this.details,
  });
}
