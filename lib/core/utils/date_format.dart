const List<String> _months = [
  'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
  'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
];

/// Date d'un signalement pour les listes : « il y a 2 h », « 14 oct. ».
///
/// - moins d'une minute : « à l'instant »
/// - moins d'une heure : « il y a 12 min »
/// - moins de 24 h : « il y a 2 h »
/// - sinon : « 14 oct. » (avec l'année si ce n'est pas l'année en cours)
///
/// [now] sert aux tests pour fixer « maintenant ».
String formatReportDate(DateTime date, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final diff = current.difference(date);

  if (diff.isNegative || diff.inMinutes < 1) return "à l'instant";
  if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'il y a ${diff.inHours} h';

  final month = _months[date.month - 1];
  return date.year == current.year
      ? '${date.day} $month'
      : '${date.day} $month ${date.year}';
}

String _two(int n) => n.toString().padLeft(2, '0');

/// « 17 oct. »
String formatDayMonth(DateTime d) => '${d.day} ${_months[d.month - 1]}';

/// « 16 oct. · 09:14 » (historique du signalement).
String formatDayMonthTime(DateTime d) =>
    '${formatDayMonth(d)} · ${_two(d.hour)}:${_two(d.minute)}';

/// « 16 oct. 2026 à 09:14 » (fiche du signalement).
String formatFullDateTime(DateTime d) =>
    '${formatDayMonth(d)} ${d.year} à ${_two(d.hour)}:${_two(d.minute)}';

/// Date d'un commentaire : « Il y a 2 h », « Hier », puis « 14 oct. ».
String formatCommentDate(DateTime date, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final diff = current.difference(date);

  if (!diff.isNegative && diff.inHours >= 24 && diff.inHours < 48) return 'Hier';

  final text = formatReportDate(date, now: current);
  return text[0].toUpperCase() + text.substring(1);
}
