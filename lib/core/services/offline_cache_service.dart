import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geo_notif_offline/core/models/place.dart';

class Bookmark {
  final Place place;
  final DateTime savedAt;

  const Bookmark({required this.place, required this.savedAt});

  Map<String, dynamic> toJson() => {
    'place': place.toJson(),
    'savedAt': savedAt.toIso8601String(),
  };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    place: Place.fromJson(json['place'] as Map<String, dynamic>),
    savedAt: DateTime.parse(json['savedAt'] as String),
  );
}

/// Persists places the user explicitly saved "for offline" from the detail
/// screen, so the app keeps real content available without connectivity.
class OfflineCacheService {
  static const _key = 'bookmarked_places';

  Future<List<Bookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((entry) => Bookmark.fromJson(jsonDecode(entry) as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isBookmarked(Place place) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any(
      (b) => b.place.lat == place.lat && b.place.lng == place.lng,
    );
  }

  Future<void> addBookmark(Place place) async {
    final bookmarks = await getBookmarks();
    if (bookmarks.any((b) => b.place.lat == place.lat && b.place.lng == place.lng)) {
      return;
    }
    bookmarks.add(Bookmark(place: place, savedAt: DateTime.now()));
    await _save(bookmarks);
  }

  Future<void> removeBookmark(Place place) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere(
      (b) => b.place.lat == place.lat && b.place.lng == place.lng,
    );
    await _save(bookmarks);
  }

  Future<void> _save(List<Bookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      bookmarks.map((b) => jsonEncode(b.toJson())).toList(),
    );
  }
}
