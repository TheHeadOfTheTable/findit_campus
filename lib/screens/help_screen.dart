// Fichier : screens/help_screen.dart
//
// Rôle : écran d'aide expliquant rapidement comment utiliser l'application.
//
// Notions abordées :
// - `StatelessWidget` ;
// - liste de consignes affichées dans un `Text`.

import 'package:flutter/material.dart';

/// Écran d'aide.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aide')),
      body: Padding(
        padding: const EdgeInsets.all(16),

        // Column : place les widgets les uns sous les autres
        child: Column(
          // Aligne tout à gauche
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            const Text(
              'Comment utiliser FindIt Campus :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // SizedBox : un espace vide
            const SizedBox(height: 16),

            // Les étapes : un Text par ligne
            const Text('1. Consultez la liste des annonces sur l\'accueil.'),
            const Text('2. Touchez une carte pour voir le détail.'),
            const Text('3. Utilisez le bouton + pour ajouter une annonce.'),
            const Text('4. Remplissez tous les champs obligatoires.'),
            const Text('5. Validez pour revenir à l\'accueil.'),

            const SizedBox(height: 16),

            // RichText : plusieurs styles dans UNE seule phrase
            RichText(
              text: const TextSpan(
                // Style de base pour toute la phrase
                style: TextStyle(fontSize: 15, color: Colors.black),
                children: [
                  // Morceau 1 : en rouge et en gras
                  TextSpan(
                    text: 'Les données ne sont pas sauvegardées : ',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Morceau 2 : style normal
                  TextSpan(text: 'elles disparaissent au redémarrage.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
