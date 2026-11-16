// Fichier : screens/item_detail_screen.dart
//
// Rôle : écran de détail d'une annonce. Il reçoit une annonce via son
// constructeur et affiche tous ses champs.
//
// Comment cet écran reçoit-il l'annonce ?
// L'écran précédent (l'accueil) crée cet écran en lui passant l'objet
// `LostItem` sélectionné : `ItemDetailScreen(item: item)`.
//
// Notions abordées :
// - passage de données entre écrans via le constructeur ;
// - `StatelessWidget` car l'écran ne modifie pas l'annonce ;
// - `Navigator` : la flèche de retour de l'AppBar suffit pour revenir ;
// - valeur par défaut (`Non renseigné`) si un champ est vide.

import 'package:flutter/material.dart';

import '../models/lost_item.dart';
import '../widgets/detail_row.dart';

/// Écran qui affiche le détail d'une annonce.
class ItemDetailScreen extends StatelessWidget {
  /// L'annonce à afficher. Elle est transmise depuis l'écran précédent.
  final LostItem item;

  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Couleur différente selon le statut, mais le texte est toujours affiché.
    final bool isLost = item.status == ItemStatus.lost;

    
    final Color statusColor = isLost ? Colors.red.shade600 : Colors.green.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'annonce'),
      ),
      body: SingleChildScrollView(
        // `SingleChildScrollView` permet de défiler si le contenu est long.
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal de l'annonce.
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Lignes de détail.
            DetailRow(
              label: 'Statut',
              value: item.status.label,
              valueColor: statusColor,
            ),
            DetailRow(label: 'Catégorie', value: item.category),
            DetailRow(label: 'Lieu', value: item.location),
            DetailRow(label: 'Date', value: item.formattedDate),
            const SizedBox(height: 12),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              // Si la description est vide, on affiche une valeur par défaut.
              item.description.trim().isEmpty
                  ? 'Non renseigné'
                  : item.description,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

