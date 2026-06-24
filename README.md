# 🌍 Orbe

Application mobile de géolocalisation **offline-first**, construite avec Flutter.
Explorez le globe, découvrez des lieux, gardez-les disponibles hors-ligne, et recevez des alertes pertinentes selon votre position — avec un design inspiré d'iOS.

## ✨ Fonctionnalités

- **Globe interactif 3D** — sphère terrestre texturée, rotation libre au glisser, avec les principaux pays/continents annotés. Toucher un pays ouvre sa fiche détail.
- **Recherche de lieux** — recherche en temps réel via OpenStreetMap (Nominatim).
- **Fiche lieu détaillée** — résumé Wikipédia, météo et fuseau horaire courants (Open-Meteo), points d'intérêt à proximité, itinéraire externe.
- **Autour de moi** — radar des points d'intérêt réels (Overpass/OSM) autour de la position GPS, avec bascule précision haute/basse.
- **Alertes** — proximité d'un POI, risque météo sur les lieux sauvegardés, nouveaux lieux ajoutés hors-ligne.
- **Mode hors-ligne** — les lieux sauvegardés restent consultables sans connexion ; bandeau d'état réseau.
- **Notifications locales** pour les alertes.

Toutes les données viennent d'API publiques gratuites, sans clé : **Nominatim**, **Open-Meteo**, **Wikipedia REST API**, **Overpass API**.

## 🏗️ Architecture

Structure en *feature-first* + *atomic design* :

```
lib/
  core/                    # partagé entre features
    models/                # Place, WeatherInfo, NearbyPoi...
    services/              # géoloc, connectivité, notifications, API
    theme/                 # couleurs, styles, thème Cupertino/Material
    widgets/atoms|molecules # composants UI réutilisables
  features/
    explorer/              # globe + recherche + lieu à la une
    detail/                # fiche détail d'un lieu
    nearby/                # radar des POI à proximité
    alerts/                # liste d'alertes
    profile/                # version app, permissions, lieux sauvegardés
    shell/                  # navigation par onglets (IndexedStack)
```

Chaque feature suit `data/` (appels API) → `domain/` (modèles/logique) → `presentation/` (screens + widgets atoms/molecules/organisms).

## 🛠️ Stack technique

| | |
|---|---|
| Framework | Flutter 3 / Dart |
| Géolocalisation | `geolocator` |
| Carte / globe | `flutter_map`, `flutter_earth_globe`, `latlong2` |
| Réseau | `http`, `connectivity_plus` |
| Stockage local | `shared_preferences` |
| Notifications | `flutter_local_notifications` |
| Liens externes | `url_launcher` |
| UI | Material 3 + composants Cupertino (look iOS) |

## 🚀 Lancer le projet

```powershell
flutter pub get
```
Installer les dépendances.

```powershell
emulator -list-avds
```
Lister les émulateurs Android disponibles.

```powershell
emulator -avd Pixel_API_34
```
Démarrer l'émulateur Android `Pixel_API_34`. Attendre que l'écran d'accueil Android s'affiche avant de continuer.

```powershell
flutter devices
```
Lister les appareils détectés (émulateur, navigateur, etc.).

```powershell
flutter run
```
Lancer l'application. Choisir l'appareil dans la liste si plusieurs sont disponibles.

```powershell
flutter run -d emulator-5554
```
Lancer directement sur l'émulateur Android sans passer par le choix interactif.

```powershell
flutter analyze
```
Vérifier l'absence d'erreurs/avertissements statiques.

```powershell
flutter clean
```
Nettoyer le build en cas d'erreur Gradle/Kotlin persistante, puis relancer `flutter run`.

## 🔌 API utilisées

| API | Usage |
|---|---|
| [Nominatim](https://nominatim.org/) | Recherche et géocodage inverse de lieux |
| [Open-Meteo](https://open-meteo.com/) | Météo courante et fuseau horaire |
| [Wikipedia REST API](https://www.mediawiki.org/wiki/API:REST_API) | Résumé descriptif et points d'intérêt géolocalisés |
| [Overpass API](https://wiki.openstreetmap.org/wiki/Overpass_API) | Points d'intérêt OpenStreetMap à proximité |

## 🙏 Crédits

- Texture terrestre (`assets/globe/earth_day.jpg`) : "Earth Day Map" par [Solar System Scope](https://www.solarsystemscope.com/textures/), licence [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), basée sur l'imagerie NASA Blue Marble.
- Données cartographiques © [OpenStreetMap](https://www.openstreetmap.org/copyright) contributors.
