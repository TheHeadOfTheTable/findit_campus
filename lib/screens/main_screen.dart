// Fichier : screens/main_screen.dart
//
// Rôle : écran principal qui contient la barre de navigation du bas
// (`BottomNavigationBar`) et qui bascule entre les différents écrans.
//
// Pourquoi ce fichier existe-t-il ?
// Plutôt que de mettre la barre de navigation dans chaque écran, on la
// centralise ici. Ainsi, l'utilisateur peut passer d'un onglet à l'autre
// sans perdre l'état des écrans.
//
// Notions abordées :
// - `StatefulWidget` et `setState()` pour changer l'onglet actif ;
// - `BottomNavigationBar` et `BottomNavigationBarItem` ;
// - liste de widgets et sélection par index.

import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'help_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// Écran principal avec navigation par onglets.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index de l'onglet actuellement sélectionné (0 = Accueil).
  int _currentIndex = 0;

  // Liste des écrans affichés selon l'onglet.
  // On utilise `const` car la liste ne change pas pendant l'exécution.
  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
    AboutScreen(),
    SettingsScreen(),
    HelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le corps affiche l'écran correspondant à l'onglet sélectionné.
      // Quand `_currentIndex` change, `setState()` reconstruit ce widget et
      // affiche le bon écran.
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // `onTap` est appelé quand l'utilisateur touche un onglet.
        // On met à jour `_currentIndex` puis on appelle `setState()` pour
        // rafraîchir l'affichage.
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // `fixed` permet d'afficher les libellés sous chaque icône.
        type: BottomNavigationBarType.fixed,
        // Couleur de l'onglet sélectionné (couleur principale du thème).
        selectedItemColor: Colors.deepOrange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'À propos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Aide'),
        ],
      ),
    );
  }
}
