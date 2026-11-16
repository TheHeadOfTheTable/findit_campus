// Fichier : widgets/item_card.dart
//
// Rôle : widget réutilisable qui affiche une annonce sous forme de carte
// (`Card`). Il est utilisé par l'écran d'accueil pour chaque élément de la
// liste.
//
// Pourquoi un widget séparé ?
// Pour éviter de répéter le code d'affichage dans `ListView.builder` et
// garder l'écran d'accueil lisible.
//
// Notions abordées :
// - `StatelessWidget` : widget sans état propre, il dépend uniquement des
//   données reçues en paramètre ;
// - passage d'un objet (`LostItem`) et d'une fonction de rappel (`onTap`)
//   via le constructeur ;
// - affichage visuel d'un statut avec couleur ET texte (pas seulement la
//   couleur, pour l'accessibilité) ;
// - `InkWell` pour rendre la carte cliquable.

import 'package:flutter/material.dart';

import '../models/lost_item.dart';

/// Carte représentant une annonce dans la liste.
class ItemCard extends StatelessWidget {
  /// L'annonce à afficher.
  final LostItem item;

  /// Fonction appelée lorsque l'utilisateur touche la carte.
  final VoidCallback callback;

  const ItemCard({super.key, required this.item, required this.callback});

  @override
  Widget build(BuildContext context) {
    // Rouge si l'objet est perdu, vert s'il est trouvé.
    final Color colorStatus = item.status == ItemStatus.lost
        ? Colors.red
        : Colors.green;

    return Card(
      child: ListTile(
        title: Text(item.title),
        subtitle: Text('${item.category} • ${item.location}'),
        trailing: Text(
          item.status.label, // "Perdu" ou "Trouvé"
          style: TextStyle(color: colorStatus, fontWeight: FontWeight.bold),
        ),
        onTap: callback,
      ),
    );
  }
}
