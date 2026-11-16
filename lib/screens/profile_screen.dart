// Fichier : screens/profile_screen.dart
//
// Rôle : écran de profil de l'étudiant. Pour ce TP, il affiche des
// informations statiques (pas d'authentification).
//
// Notions abordées :
// - `StatelessWidget` ;
// - mise en page avec `Column`, `CircleAvatar`, `ListTile` ;
// - `ListView` pour rendre le contenu défilable.

import 'package:flutter/material.dart';

/// Écran de profil (données fictives, sans connexion).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      // `ListView` permet de faire défiler le contenu si l'écran est petit.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          // Avatar centré en haut.
          const Center(
            child: CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 48),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Étudiant FindIt',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          // Informations fictives.
          const ListTile(
            leading: Icon(Icons.school),
            title: Text('Campus'),
            subtitle: Text('Université - Site principal'),
          ),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            subtitle: Text('etudiant@campus.fr'),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Rôle'),
            subtitle: Text('Utilisateur (pas d\'authentification dans ce TP)'),
          ),
        ],
      ),
    );
  }
}
