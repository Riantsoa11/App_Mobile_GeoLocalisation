import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:geo_notif_offline/core/models/place.dart';
import 'package:geo_notif_offline/features/explorer/data/continents.dart';

/// A real textured, auto-rotating 3D Earth globe (flutter_earth_globe package)
/// with tappable points for featured places and curated country labels.
/// Drag-to-rotate, zoom and auto-rotation pause-on-drag are handled
/// internally by the package.
///
/// Earth day texture (assets/globe/earth_day.jpg): "2K/8K Earth Day Map" by
/// Solar System Scope (solarsystemscope.com/textures), licensed CC BY 4.0,
/// based on NASA Blue Marble imagery.
class RealEarthGlobe extends StatefulWidget {
  final List<Place> featuredPlaces;
  final List<Color> featuredColors;
  final ValueChanged<Place> onPlaceTap;

  const RealEarthGlobe({
    super.key,
    required this.featuredPlaces,
    required this.featuredColors,
    required this.onPlaceTap,
  });

  @override
  State<RealEarthGlobe> createState() => _RealEarthGlobeState();
}

class _RealEarthGlobeState extends State<RealEarthGlobe> {
  late final FlutterEarthGlobeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.15,
      isRotating: true,
      zoom: 1,
      minZoom: -0.5,
      maxZoom: 2.5,
      background: const AssetImage('assets/globe/stars.jpg'),
      surface: const AssetImage('assets/globe/earth_day.jpg'),
    );
    _addPoints();
  }

  void _addPoints() {
    for (var i = 0; i < widget.featuredPlaces.length; i++) {
      final place = widget.featuredPlaces[i];
      final color = widget.featuredColors[i % widget.featuredColors.length];
      _controller.addPoint(
        Point(
          id: 'place-${place.name}',
          coordinates: GlobeCoordinates(place.lat, place.lng),
          label: place.name,
          isLabelVisible: true,
          style: PointStyle(color: color, size: 5),
          labelTextStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          onTap: () => widget.onPlaceTap(place),
        ),
      );
    }

    for (final continent in kContinents) {
      for (final country in continent.countries) {
        _controller.addPoint(
          Point(
            id: 'country-${country.country}',
            coordinates: GlobeCoordinates(country.lat, country.lng),
            label: country.country,
            isLabelVisible: true,
            style: PointStyle(color: continent.color, size: 4),
            labelTextStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            onTap: () => widget.onPlaceTap(
              Place(name: country.country, lat: country.lat, lng: country.lng),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = constraints.biggest.shortestSide / 2 * 0.9;
        return FlutterEarthGlobe(controller: _controller, radius: radius);
      },
    );
  }
}
