// Fichier : main.dart
//
// Rôle : point d'entrée de l'application Flutter.
// Ce fichier est le premier exécuté au lancement. Il configure l'application
// (thème, écran de départ) puis l'affiche à l'écran.
//
// Notions abordées :
// - fonction `main()` : point d'entrée d'un programme Dart ;
// - `runApp()` : démarre Flutter et affiche le widget racine ;
// - `MaterialApp` : enveloppe toute l'application (thème, navigation) ;
// - `ThemeData` et `ColorScheme.fromSeed` : palette de couleurs Material 3.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// On importe l'écran principal qui contient la barre de navigation.
import 'screens/main_screen.dart';

void main() {
  // SQLite dans le navigateur :
  // `sqflite` seul ne fonctionne que sur téléphone. Quand l'appli tourne
  // dans un navigateur (`kIsWeb` vaut `true`), on lui dit d'utiliser la
  // version "web" de SQLite. La base est alors sauvegardée dans le
  // navigateur (IndexedDB) et survit au rafraîchissement de la page.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // `runApp` prend un widget et l'affiche à l'écran.
  // Ici le widget racine est `FindItCampusApp`.
  runApp(const FindItCampusApp());
}

/// Widget racine de l'application.
///
/// C'est un `StatelessWidget` car la configuration de l'application ne change
/// pas pendant l'exécution.
class FindItCampusApp extends StatelessWidget {
  const FindItCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Titre de l'application (affiché par l'OS, pas forcément à l'écran).
      title: 'FindIt Campus',
      // Masque la bannière "DEBUG" en haut à droite.
      debugShowCheckedModeBanner: false,
      // Thème Material 3 avec une couleur principale bleue.
      // `ColorScheme.fromSeed` génère automatiquement une palette cohérente.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // Écran affiché au démarrage : l'écran principal avec la barre de
      // navigation du bas.
      home: const MainScreen(),
    );
  }
}
