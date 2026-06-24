class WeatherInfo {
  final double tempC;
  final int weatherCode;
  final String timezone;
  final int utcOffsetSeconds;

  const WeatherInfo({
    required this.tempC,
    required this.weatherCode,
    required this.timezone,
    required this.utcOffsetSeconds,
  });

  /// WMO weather codes: 61-99 cover rain, showers, thunderstorms, snow.
  bool get isRisky => weatherCode >= 61 && weatherCode <= 99;

  String get gmtLabel {
    final hours = utcOffsetSeconds / 3600;
    final sign = hours >= 0 ? '+' : '';
    return 'GMT$sign${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)}';
  }
}
