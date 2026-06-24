# geo_notif_offline

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Lancer le projet

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
flutter clean
```
Nettoyer le build en cas d'erreur Gradle/Kotlin persistante, puis relancer `flutter run`.

## Crédits

- Texture terrestre (`assets/globe/earth_day.jpg`) : "Earth Day Map" par [Solar System Scope](https://www.solarsystemscope.com/textures/), licence [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), basée sur l'imagerie NASA Blue Marble.
