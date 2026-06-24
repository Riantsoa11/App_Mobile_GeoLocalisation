class NearbyPoi {
  final String name;
  final String category;
  final double lat;
  final double lng;
  final double distanceMeters;
  final double bearingDegrees;

  const NearbyPoi({
    required this.name,
    required this.category,
    required this.lat,
    required this.lng,
    required this.distanceMeters,
    required this.bearingDegrees,
  });

  String get distanceLabel => distanceMeters < 1000
      ? '${distanceMeters.round()} m'
      : '${(distanceMeters / 1000).toStringAsFixed(1)} km';

  /// Coarse 8-point compass direction (N, N-E, E, S-E, S, S-O, O, N-O).
  String get compassLabel {
    const labels = ['N', 'N-E', 'E', 'S-E', 'S', 'S-O', 'O', 'N-O'];
    final index = (((bearingDegrees % 360) + 22.5) ~/ 45) % 8;
    return labels[index];
  }
}
