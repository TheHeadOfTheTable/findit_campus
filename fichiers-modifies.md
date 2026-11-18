# Fichiers touchés pour l'ajout de SQLite

## Créés
- `lib/data/database_helper.dart` : tout le code SQLite (ouverture de la base, création de la table, lecture, ajout)
- `guide-sqllite.md` : guide pour les débutants
- `fichiers-modifies.md` : ce fichier

## Modifiés
- `lib/models/lost_item.dart` : ajout de `toMap()` et `fromMap()`
- `lib/screens/home_screen.dart` : chargement depuis la base au démarrage, sauvegarde à l'ajout, indicateur de chargement
- `lib/data/sample_items.dart` : mise à jour du commentaire d'en-tête (les exemples remplissent la base au 1er lancement)
- `pubspec.yaml` : ajout des dépendances `sqflite` et `path`
- `README.md` : mention de SQLite dans les fonctionnalités, les concepts et les limites

## Modifiés automatiquement par Flutter (`flutter pub add`)
- `pubspec.lock` : versions exactes des paquets installés
- `macos/Flutter/GeneratedPluginRegistrant.swift` : enregistrement du plugin sqflite pour macOS
