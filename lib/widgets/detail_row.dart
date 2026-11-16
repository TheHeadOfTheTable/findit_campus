import 'package:flutter/material.dart';

/// Petit widget utilitaire pour afficher une ligne "libellé : valeur".
///
/// On le garde dans le même fichier car il n'est utilisé qu'ici.
/// Le `_` devant le nom indique qu'il est privé à ce fichier.
class DetailRow extends StatelessWidget {
  final String label; // Texte du label (ex. "Statut", "Catégorie", etc.)
  final String
  value; // Texte de la valeur correspondante (ex. "Perdu", "Clés", etc.)
  final Color? valueColor; // Couleur optionnelle pour la valeur (ex. rouge pour "Perdu", vert pour "Trouvé")

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Libellé sur une largeur fixe pour aligner les valeurs.
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              // Valeur de secours si un champ est vide.
              value.trim().isEmpty ? 'Non renseigné' : value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
