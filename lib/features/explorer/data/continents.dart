import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

class ContinentLabel {
  final String country;
  final double lat;
  final double lng;

  const ContinentLabel({required this.country, required this.lat, required this.lng});
}

class Continent {
  final String name;
  final Color color;
  final List<ContinentLabel> countries;

  const Continent({required this.name, required this.color, required this.countries});
}

/// Country labels shown on the real-textured globe, grouped by continent.
/// Coordinates point at well-known capitals/centroids, not at precise borders.
const kContinents = <Continent>[
  Continent(
    name: 'Afrique',
    color: AppColors.warning,
    countries: [
      ContinentLabel(country: 'Egypte', lat: 26, lng: 30),
      ContinentLabel(country: 'Nigeria', lat: 9, lng: 8),
      ContinentLabel(country: 'Afrique du Sud', lat: -29, lng: 24),
    ],
  ),
  Continent(
    name: 'Asie',
    color: AppColors.violet,
    countries: [
      ContinentLabel(country: 'Chine', lat: 35, lng: 103),
      ContinentLabel(country: 'Inde', lat: 21, lng: 78),
      ContinentLabel(country: 'Japon', lat: 36, lng: 138),
    ],
  ),
  Continent(
    name: 'Europe',
    color: AppColors.accent,
    countries: [
      ContinentLabel(country: 'France', lat: 47, lng: 2),
      ContinentLabel(country: 'Allemagne', lat: 51, lng: 10),
      ContinentLabel(country: 'Italie', lat: 43, lng: 12),
    ],
  ),
  Continent(
    name: 'Amerique du Nord',
    color: AppColors.pink,
    countries: [
      ContinentLabel(country: 'Etats-Unis', lat: 39, lng: -98),
      ContinentLabel(country: 'Canada', lat: 56, lng: -106),
      ContinentLabel(country: 'Mexique', lat: 23, lng: -102),
    ],
  ),
  Continent(
    name: 'Amerique du Sud',
    color: AppColors.green,
    countries: [
      ContinentLabel(country: 'Bresil', lat: -10, lng: -55),
      ContinentLabel(country: 'Argentine', lat: -34, lng: -64),
      ContinentLabel(country: 'Perou', lat: -10, lng: -75),
    ],
  ),
  Continent(
    name: 'Oceanie',
    color: AppColors.blueAccent,
    countries: [
      ContinentLabel(country: 'Australie', lat: -25, lng: 134),
    ],
  ),
];
