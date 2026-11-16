// Fichier : screens/settings_screen.dart
//
// Rôle : écran de paramètres simples (préférences fictives).
//
// Notions abordées :
// - `StatefulWidget` et `setState()` pour un interrupteur ;
// - `SwitchListTile` pour afficher un réglage avec un interrupteur.

import 'package:flutter/material.dart';

/// Écran de paramètres simples.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Préférences fictives conservées en mémoire.
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Recevoir des alertes (fictif)'),
            value: _notificationsEnabled,
            // Quand l'utilisateur bascule l'interrupteur, on met à jour la
            // valeur et on appelle `setState()` pour rafraîchir l'affichage.
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Non appliqué dans ce TP'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
