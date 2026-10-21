import '../../core/models/report.dart';

/// Filtre choisi dans les onglets de « Mon espace ».
enum ReportFilter {
  all('Tous'),
  inProgress('En cours'),
  resolved('Résolus');

  const ReportFilter(this.label);
  final String label;

  /// Le signalement doit-il apparaître avec ce filtre ?
  bool matches(Report report) => switch (this) {
        ReportFilter.all => true,
        ReportFilter.inProgress => report.status == ReportStatus.inProgress,
        ReportFilter.resolved => report.status == ReportStatus.resolved,
      };
}
