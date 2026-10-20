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
