class Place {
  final String name;
  final double lat;
  final double lng;
  final String? country;
  final String? region;

  const Place({
    required this.name,
    required this.lat,
    required this.lng,
    this.country,
    this.region,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'lat': lat,
    'lng': lng,
    'country': country,
    'region': region,
  };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    name: json['name'] as String,
    lat: json['lat'] as double,
    lng: json['lng'] as double,
    country: json['country'] as String?,
    region: json['region'] as String?,
  );
}
