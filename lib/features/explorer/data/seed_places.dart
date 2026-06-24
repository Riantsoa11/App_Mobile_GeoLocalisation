import 'package:geo_notif_offline/core/models/place.dart';

/// Curated anchors used to populate the globe's default pins and the
/// Explorer "featured place" card. Only names + coordinates are hardcoded;
/// every other detail shown in the app (weather, timezone, distance,
/// description, points of interest) is fetched live from real APIs.
const kFeaturedPlaces = <Place>[
  Place(name: 'Tokyo', lat: 35.6762, lng: 139.6503, country: 'Japon'),
  Place(name: 'Lisbonne', lat: 38.7223, lng: -9.1393, country: 'Portugal'),
  Place(name: 'Kyoto', lat: 35.0116, lng: 135.7681, country: 'Japon'),
  Place(name: 'Santorin', lat: 36.3932, lng: 25.4615, country: 'Grece'),
  Place(name: 'Paris', lat: 48.8566, lng: 2.3522, country: 'France'),
  Place(name: 'Reykjavik', lat: 64.1466, lng: -21.9426, country: 'Islande'),
  Place(name: 'Marrakech', lat: 31.6295, lng: -7.9811, country: 'Maroc'),
];
