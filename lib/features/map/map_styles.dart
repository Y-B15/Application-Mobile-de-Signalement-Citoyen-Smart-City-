/// Styles Google Maps (JSON) pour que le fond de carte suive le design :
/// gris très doux en clair, anthracite en sombre, sans icônes de commerces.
///
/// Le fond de la maquette Figma est une capture d'écran ; ces styles s'en
/// approchent (couleurs et densité de détails), le tracé exact des rues vient
/// de Google Maps.
abstract final class MapStyles {
  static const String light = r'''
[
  {"elementType":"geometry","stylers":[{"color":"#eceff1"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#64748b"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#f8fafc"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f5f6f7"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#d6dee4"}]}
]
''';

  static const String dark = r'''
[
  {"elementType":"geometry","stylers":[{"color":"#1b1f26"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#94a3b8"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#15181d"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#2b313b"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#323945"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3a424f"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#10141a"}]}
]
''';
}
