import '../models/new_report.dart';
import '../models/report.dart';

/// Contrat d'accès aux signalements de l'utilisateur connecté.
///
/// Les écrans dépendent de cette classe, pas de Firebase. Aujourd'hui on
/// utilise [MockReportsRepository] ; plus tard on écrira un
/// `FirestoreReportsRepository` sans toucher aux écrans.
abstract class ReportsRepository {
  /// Signalements de l'utilisateur connecté (écran « Mon espace »).
  Future<List<Report>> fetchMyReports();

  /// Signalements visibles sur la carte (tous les citoyens, avec position GPS).
  Future<List<Report>> fetchMapReports();

  /// Envoie un nouveau signalement et retourne son numéro de suivi (« CA-2050 »).
  Future<String> submitReport(NewReport report);
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
            String address, Duration ago, ReportStatus status) =>
        Report(
          id: id,
          trackingNumber: no,
          category: cat,
          title: title,
          address: address,
          createdAt: now.subtract(ago),
          status: status,
        );

    const p = ReportCategory.pothole;
    const l = ReportCategory.streetLight;
    const d = ReportCategory.illegalDump;
    const sRep = ReportStatus.reported;
    const sProg = ReportStatus.inProgress;
    const sRes = ReportStatus.resolved;

    return [
      r('1', 'CA-2048', p, 'Nid-de-poule dangereux', 'Rue Hassan II', const Duration(hours: 2), sProg),
      r('2', 'CA-2041', l, 'Lampadaire défectueux', 'Bd Zerktouni', const Duration(days: 4), sRes),
      r('3', 'CA-2036', d, 'Dépôt sauvage', 'Av. des FAR', const Duration(days: 7), sRep),
      r('4', 'CA-2029', p, 'Nid-de-poule', 'Rue Allal Ben Abdellah', const Duration(days: 15), sRes),
      r('5', 'CA-2024', l, 'Éclairage public en panne', "Bd d'Anfa", const Duration(days: 18), sProg),
      r('6', 'CA-2019', d, 'Gravats abandonnés', 'Rue Mohammed V', const Duration(days: 24), sRes),
      r('7', 'CA-2011', p, 'Chaussée affaissée', 'Bd Ghandi', const Duration(days: 31), sProg),
      r('8', 'CA-2004', l, 'Lampadaire penché', 'Rue Ibn Tachfine', const Duration(days: 38), sRes),
      r('9', 'CA-1996', d, 'Dépôt de déchets', 'Rue Al Massira', const Duration(days: 45), sRes),
      r('10', 'CA-1987', p, 'Nid-de-poule profond', 'Bd Bir Anzarane', const Duration(days: 52), sRes),
      r('11', 'CA-1975', l, 'Éclairage défaillant', 'Rue Abdelmoumen', const Duration(days: 60), sRes),
      r('12', 'CA-1968', d, 'Dépôt sauvage', 'Rue Jean Jaurès', const Duration(days: 70), sRes),
    ];
  }

  /// Neuf signalements autour du centre de la carte, aux positions des repères
  /// de la maquette Figma (centre : 33.5883, -7.6322, zoom 16).
  @override
  Future<List<Report>> fetchMapReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    Report r(String id, String no, ReportCategory cat, String title,
            String address, Duration ago, ReportStatus status, double lat,
            double lng) =>
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
      r('m1', 'CA-2048', p, 'Nid-de-poule dangereux', 'Rue Hassan II', const Duration(hours: 2), sProg, 33.589766, -7.634088),
      r('m2', 'CA-2049', l, 'Lampadaire défectueux', 'Bd Zerktouni', const Duration(days: 1), sRep, 33.586763, -7.635032),
      r('m3', 'CA-2036', d, 'Dépôt sauvage', 'Av. des FAR', const Duration(days: 11), sRes, 33.586548, -7.630913),
      r('m4', 'CA-2029', p, 'Nid-de-poule', 'Rue Allal Ben Abdellah', const Duration(days: 15), sRes, 33.588765, -7.635118),
      r('m5', 'CA-2024', l, 'Éclairage public en panne', 'Bd d\'Anfa', const Duration(days: 3), sProg, 33.59091, -7.633144),
      r('m6', 'CA-2019', d, 'Gravats abandonnés', 'Rue Mohammed V', const Duration(days: 5), sProg, 33.588443, -7.631943),
      r('m7', 'CA-2011', p, 'Chaussée affaissée', 'Bd Ghandi', const Duration(days: 2), sRep, 33.590552, -7.629368),
      r('m8', 'CA-2004', l, 'Lampadaire penché', 'Rue Ibn Tachfine', const Duration(days: 20), sRes, 33.587943, -7.629539),
      r('m9', 'CA-1996', d, 'Dépôt de déchets', 'Rue Al Massira', const Duration(days: 30), sRes, 33.585404, -7.633487),
    ];
  }

  /// Démonstration : attend un peu puis renvoie un numéro de suivi fictif.
  /// Plus tard : écrire dans Firestore et envoyer la photo dans Storage.
  @override
  Future<String> submitReport(NewReport report) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return 'CA-2050';
  }
}
