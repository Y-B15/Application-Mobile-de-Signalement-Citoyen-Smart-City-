import '../models/report.dart';

/// Contrat d'accès aux signalements de l'utilisateur connecté.
///
/// Les écrans dépendent de cette classe, pas de Firebase. Aujourd'hui on
/// utilise [MockReportsRepository] ; plus tard on écrira un
/// `FirestoreReportsRepository` sans toucher aux écrans.
abstract class ReportsRepository {
  Future<List<Report>> fetchMyReports();
}

/// Données de démonstration : 12 signalements = 1 signalé + 3 en cours + 8 résolus
/// (mêmes chiffres que la maquette Figma).
class MockReportsRepository implements ReportsRepository {
  const MockReportsRepository();

  @override
  Future<List<Report>> fetchMyReports() async {
    // Simule un appel réseau pour voir l'état de chargement.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    Report r(String id, String no, ReportCategory cat, String title,
            String address, Duration ago, ReportStatus status, double lat, double lng) =>
        Report(
          id: id,
          trackingNumber: no,
          category: cat,
          title: title,
          address: address,
          createdAt: now.subtract(ago),
          status: status,
          latitude: lat,
          longitude: lng,
        );

    const p = ReportCategory.pothole;
    const l = ReportCategory.streetLight;
    const d = ReportCategory.illegalDump;
    const sRep = ReportStatus.reported;
    const sProg = ReportStatus.inProgress;
    const sRes = ReportStatus.resolved;

    return [
      r('1', 'CA-2048', p, 'Nid-de-poule dangereux', 'Rue Hassan II', const Duration(hours: 2), sProg, 33.5892, -7.6180),
      r('2', 'CA-2041', l, 'Lampadaire défectueux', 'Bd Zerktouni', const Duration(days: 4), sRes, 33.5840, -7.6310),
      r('3', 'CA-2036', d, 'Dépôt sauvage', 'Av. des FAR', const Duration(days: 7), sRep, 33.5950, -7.6110),
      r('4', 'CA-2029', p, 'Nid-de-poule', 'Rue Allal Ben Abdellah', const Duration(days: 15), sRes, 33.5910, -7.6140),
      r('5', 'CA-2024', l, 'Éclairage public en panne', "Bd d'Anfa", const Duration(days: 18), sProg, 33.5820, -7.6400),
      r('6', 'CA-2019', d, 'Gravats abandonnés', 'Rue Mohammed V', const Duration(days: 24), sRes, 33.5930, -7.6100),
      r('7', 'CA-2011', p, 'Chaussée affaissée', 'Bd Ghandi', const Duration(days: 31), sProg, 33.5680, -7.6480),
      r('8', 'CA-2004', l, 'Lampadaire penché', 'Rue Ibn Tachfine', const Duration(days: 38), sRes, 33.5900, -7.5800),
      r('9', 'CA-1996', d, 'Dépôt de déchets', 'Rue Al Massira', const Duration(days: 45), sRes, 33.5780, -7.6320),
      r('10', 'CA-1987', p, 'Nid-de-poule profond', 'Bd Bir Anzarane', const Duration(days: 52), sRes, 33.5740, -7.6380),
      r('11', 'CA-1975', l, 'Éclairage défaillant', 'Rue Abdelmoumen', const Duration(days: 60), sRes, 33.5770, -7.6220),
      r('12', 'CA-1968', d, 'Dépôt sauvage', 'Rue Jean Jaurès', const Duration(days: 70), sRes, 33.5860, -7.6250),
    ];
  }
}
