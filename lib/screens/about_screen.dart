// Fichier : screens/about_screen.dart
//
// Rôle : écran "À propos" qui présente l'application et ses limites.
//
// Notions abordées :
// - `StatelessWidget` ;
// - affichage de texte simple dans un `Padding`.

import 'package:flutter/material.dart';

/// Écran "À propos" de l'application.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // ============================================================
  // Sans RichText, il faudrait créer plusieurs widgets `Text`
  // séparés (dans une Row ou une Column). Résultat :
  //   - le texte ne passe plus correctement à la ligne,
  //   - c'est compliqué à aligner,
  //   - le code devient long et difficile à lire.
  //
  // Avec RichText, on garde UN SEUL bloc de texte qui s'écoule
  // naturellement, tout en stylisant chaque morceau séparément.
  //
  // ============================================================
  // COMMENT ÇA MARCHE ?
  // ============================================================
  // RichText contient un `TextSpan` (le texte principal), qui lui-même
  // contient une liste de `children` (les morceaux de texte).
  // Chaque morceau est un `TextSpan` avec son propre style.
  //
  // Exemples d'utilisation courante :
  //   - mettre un mot important en gras ou en couleur,
  //   - afficher "Conditions d'utilisation" en bleu souligné,
  //   - écrire un prix barré à côté d'un prix promo.
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        // Couleur d'arrière-plan de l'AppBar
        backgroundColor: const Color.fromARGB(255, 6, 31, 74),
      ),
      body: Padding(
        // Marge de 16 pixels autour du contenu
        padding: const EdgeInsets.all(16),
        child: RichText(
          text: TextSpan(
            // Style PAR DÉFAUT : tous les TextSpan enfants en héritent
            // (si on ne précise pas de style pour eux)
            style: const TextStyle(
              fontSize: 15,
              height: 1.5, // espacement entre les lignes
              color: Colors.black, // IMPORTANT : sans couleur, le texte peut être invisible
            ),

            // "children" contient la liste des morceaux de texte
            children: const [
              // Morceau 1 : le nom de l'application en gras et en bleu
              TextSpan(
                text: 'FindIt Campus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),

              // Morceau 2 : texte normal (style par défaut)
              TextSpan(
                text:
                    ' est une application mobile Flutter permettant aux '
                    'étudiants de déclarer et consulter des objets perdus '
                    'ou trouvés sur le campus.\n\n',
              ),

              // Morceau 3 : texte normal
              TextSpan(
                text:
                    'Ce projet est un TP de 2 heures destiné à des débutants. '
                    'Les données restent en mémoire et ',
              ),

              // Morceau 4 : mise en évidence en gras et en rouge
              TextSpan(
                text: 'ne sont pas persistantes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              // Morceau 5 : suite du texte normal
              TextSpan(
                text:
                    ' : elles disparaissent à la fermeture de '
                    'l\'application.\n\n',
              ),

              // Morceau 6 : texte en italique
              TextSpan(
                text:
                    'Aucun backend, authentification, photo ni géolocalisation '
                    'n\'est utilisé dans cette version.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
