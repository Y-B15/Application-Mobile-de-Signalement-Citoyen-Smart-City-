import 'package:cityalert/core/utils/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 18, 12, 0);

  test("moins d'une minute", () {
    expect(formatReportDate(now.subtract(const Duration(seconds: 20)), now: now),
        "à l'instant");
  });

  test('minutes', () {
    expect(formatReportDate(now.subtract(const Duration(minutes: 12)), now: now),
        'il y a 12 min');
  });

  test('heures', () {
    expect(formatReportDate(now.subtract(const Duration(hours: 2)), now: now),
        'il y a 2 h');
  });

  test('jours, même année', () {
    expect(formatReportDate(DateTime(2026, 10, 14, 9), now: now), '14 oct.');
  });

  test('année précédente', () {
    expect(formatReportDate(DateTime(2025, 12, 31, 9), now: now), '31 déc. 2025');
  });
}
